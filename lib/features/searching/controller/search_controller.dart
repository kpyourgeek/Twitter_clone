import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/apis/user_api.dart';
import 'package:the_iconic/models/user_model.dart';

final searchControllerProvider = StateNotifierProvider((ref) {
  final userApi = ref.watch(userApiProvider);
  return SearchController(userApi: userApi);
});

final searchUserProvider =
    FutureProvider.family.autoDispose((ref, String name) async {
  final searchUserController = ref.watch(searchControllerProvider.notifier);
  return searchUserController.searchUser(name);
});

class SearchController extends StateNotifier<bool> {
  final UserApi _userApi;
  SearchController({required UserApi userApi})
      : _userApi = userApi,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userApi.searchUserByName(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
