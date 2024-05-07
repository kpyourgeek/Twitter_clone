import 'package:appwrite/models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/apis/auth_api.dart';
import 'package:the_iconic/apis/user_api.dart';
import 'package:the_iconic/core/utilis.dart';
import 'package:the_iconic/features/auth/home/view/home_view.dart';
import 'package:the_iconic/features/auth/view/login_view.dart';
import 'package:the_iconic/models/user_model.dart';

// provider for My aunthentication Api

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authApi = ref.watch(authAPIProvider);
  final userApi = ref.watch(userApiProvider);

  return AuthController(authApi: authApi, userApi: userApi);
});

// Provider for getting user deetails
final userDetailsProvider = FutureProvider.family((ref, String uid) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

// provider for getting current user details
final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

//provider for getting current user who have logged in already

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authAPI;
  final UserApi _userAPI;

  AuthController({required AuthApi authApi, required UserApi userApi})
      : _authAPI = authApi,
        _userAPI = userApi,
        super(false);

  // state = isLoading;

  // _account.get()!=null ? HomeScreen : LogInScreen

  Future<User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      UserModel userModel = UserModel(
        name: getNameFromEmail(email),
        email: email,
        followers: const [],
        following: const [],
        profilePic: '',
        bannerPic: '',
        // ***** very huge bug , it's not giving user id why ? on video you were on 2:57 Hrs
        uid: r.$id,
        bio: '',
        isTwitterBlue: false,
      );
      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(
          context,
          'account created successfuly , Login please',
        );
        Navigator.push(
          context,
          LoginView.route(),
        );
      });
    });
  }

  void logIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res = await _authAPI.logIn(email: email, password: password);
    state = false;
    res.fold((l) {
      showSnackBar(
        context,
        l.message.toString(),
      );
    }, (r) {
      Navigator.push(context, HomeView.route());
    });
  }

  void logOut(BuildContext context) async {
    state = true;
    final res = await _authAPI.logOut();
    state = false;
    res.fold((l) {
      showSnackBar(
        context,
        l.message.toString(),
      );
    }, (r) {
      showSnackBar(
        context,
        'Logged out successfully',
      );
      Navigator.push(
        context,
        LoginView.route(),
      );
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}
