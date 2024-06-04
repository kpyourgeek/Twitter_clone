import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/apis/tweet_api.dart';
import 'package:the_iconic/models/tweet_model.dart';

final userProfilleControllerProvider = StateNotifierProvider((ref) {
  final tweetApi = ref.watch(tweetApiProvider);
  return UserProfilleController(tweetApi: tweetApi);
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userProfilleController =
      ref.watch(userProfilleControllerProvider.notifier);
  return userProfilleController.getUserTweets(uid);
});

class UserProfilleController extends StateNotifier<bool> {
  final TweetApi _tweetApi;
  UserProfilleController({required TweetApi tweetApi})
      : _tweetApi = tweetApi,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final documents = await _tweetApi.getUserTweets(uid);
    final listOfUserTwets =
        documents.map((e) => Tweet.fromMap(e.data)).toList();
    return listOfUserTwets;
  }
}
