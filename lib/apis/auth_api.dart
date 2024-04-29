import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_iconic/constants/appwrite/appwrite_providers.dart';
import 'package:the_iconic/core/type_definitions.dart';
import 'package:the_iconic/errors/responses.dart';

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthApi(account: account);
});

abstract class IAuthApi {
  FutureEither<String> signUp({
    required String email,
    required String password,
  });

  FutureEither<String> logIn({required String email, required String password});
  Future<UserResponse> currentUserAccount();
  FutureEitherVoid logOut();
}

class AuthApi implements IAuthApi {
  final Account _account;
  AuthApi({
    required Account account,
  }) : _account = account;
  User? _cachedUser;

  // caching user

  @override
  Future<UserResponse> currentUserAccount({bool forceRefresh = false}) async {
    if (_cachedUser != null && forceRefresh == false) {
      return UserResponse(user: _cachedUser!);
    }
    try {
      final loggedInUser = await _account.get();
      _cachedUser = loggedInUser;
    } on AppwriteException catch (e) {
      if (e.message != null &&
          e.message!.contains('Failed host lookup: \'cloud.appwrite.io\'')) {
        return const UserResponse(
          user: null,
          errorMessage:
              'Network error. Please check your internet connection and try again.',
        );
      }
    } catch (e) {
      return UserResponse(user: null, errorMessage: e.toString());
    }
    return const UserResponse(user: null, errorMessage: 'Unexpected error');
  }

// creating a user in an appwrite

  @override
  FutureEither<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );

      return right(account.$createdAt);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message.toString(), stackTrace),
      );
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  // leting user enter an app, through sign in

  @override
  FutureEither<String> logIn(
      {required String email, required String password}) async {
    try {
      final account =
          await _account.createEmailSession(email: email, password: password);
      return right(
        account.userId.toString(),
      );
    } on AppwriteException catch (e, stackTrace) {
      return (left(Failure(e.message.toString(), stackTrace)));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid logOut() async {
    try {
      await _account.deleteSessions();
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure('Retry', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure('Retry', stackTrace),
      );
    }
  }
}

// FutureFailureOr<void> signOut() async {
//   try {
//     await _account.deleteSessions();
//     return right(null);
//   } on AppwriteException catch (e, stackTrace) {
//     return left(
//       FailureResponse(e.message ?? 'Unexpected error', stackTrace),
//     );
//   } catch (e, stackTrace) {
//     return left(
//       FailureResponse(e.toString(), stackTrace),
//     );
//   }
// }
