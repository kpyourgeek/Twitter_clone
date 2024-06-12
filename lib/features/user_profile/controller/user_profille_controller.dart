import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/apis/storage_api.dart';
import 'package:the_iconic/apis/tweet_api.dart';
import 'package:the_iconic/apis/user_api.dart';
import 'package:the_iconic/core/utilis.dart';
import 'package:the_iconic/models/tweet_model.dart';
import 'package:the_iconic/models/user_model.dart';

final userProfilleControllerProvider =
    StateNotifierProvider<UserProfilleController, bool>((ref) {
  final tweetApi = ref.watch(tweetApiProvider);
  final storageApi = ref.watch(storageApiProvider);
  final userApi = ref.watch(userApiProvider);

  return UserProfilleController(
      tweetApi: tweetApi, storageApi: storageApi, userApi: userApi);
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userProfilleController =
      ref.watch(userProfilleControllerProvider.notifier);
  return userProfilleController.getUserTweets(uid);
});

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final userAPI = ref.watch(userApiProvider);
  return userAPI.getLatestUserProfileData();
});

class UserProfilleController extends StateNotifier<bool> {
  final TweetApi _tweetApi;
  final StorageApi _storageApi;
  final UserApi _userApi;

  UserProfilleController(
      {required TweetApi tweetApi,
      required StorageApi storageApi,
      required UserApi userApi})
      : _tweetApi = tweetApi,
        _storageApi = storageApi,
        _userApi = userApi,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final documents = await _tweetApi.getUserTweets(uid);
    final listOfUserTwets =
        documents.map((e) => Tweet.fromMap(e.data)).toList();
    return listOfUserTwets;
  }

  void updateUserProfile(
      {required UserModel userModel,
      required BuildContext context,
      required File? bannerImage,
      required File? profileImage}) async {
    state = true;
    if (bannerImage != null) {
      final bannerUrl = await _storageApi.uploadImages(
        [bannerImage],
      );
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }
    if (profileImage != null) {
      final profileUrl = await _storageApi.uploadImages(
        [profileImage],
      );
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }
    final res = await _userApi.updateUserProfile(userModel);
    state = false;
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Navigator.pop(context);
    });
  }
}
