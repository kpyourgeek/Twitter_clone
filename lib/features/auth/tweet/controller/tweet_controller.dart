import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/apis/storage_api.dart';
import 'package:the_iconic/apis/tweet_api.dart';
import 'package:the_iconic/controller/auth_controller.dart';
import 'package:the_iconic/core/enums/tweet_type_enum.dart';
import 'package:the_iconic/core/utilis.dart';
import 'package:the_iconic/models/tweet_model.dart';
import 'package:the_iconic/models/user_model.dart';

// Provider for my class

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    final tweetApi = ref.watch(tweetApiProvider);
    final storageApi = ref.watch(storageApiProvider);
    return TweetController(
        ref: ref, tweetApi: tweetApi, storageApi: storageApi);
  },
);

// Provider for geeting my tweets .............

final getTweetsProvider = FutureProvider(
  (ref) {
    final tweetController = ref.watch(tweetControllerProvider.notifier);
    return tweetController.getTweets();
  },
);

// Provider for getting all replies on my tweet
final getRepliestoTweetProvider = FutureProvider.family(
  (ref, Tweet tweet) {
    final tweetController = ref.watch(tweetControllerProvider.notifier);
    return tweetController.getRepliesTo(tweet);
  },
);

// Provider for getting latest tweets just tweeted......

final getLatestTweetProvider = StreamProvider((ref) {
  final tweetApi = ref.watch(tweetApiProvider);
  return tweetApi.getLatestTweet();
});
// provider for getting tweet by id

final getTweetByIdProvider = FutureProvider.family((ref, String id) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});

// getting user latest tweets

final getUserLatestTweetProvider = StreamProvider((ref) {
  final tweetApi = ref.watch(tweetApiProvider);
  return tweetApi.getUserLatestTweets();
});

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final TweetApi _tweetApi;
  final StorageApi _storageApi;

  TweetController({
    required Ref ref,
    required TweetApi tweetApi,
    required StorageApi storageApi,
  })  : _ref = ref,
        _tweetApi = tweetApi,
        _storageApi = storageApi,
        super(false);

// funnctionon for fetching tweets
  Future<List<Tweet>> getTweets() async {
    final tweetsList = await _tweetApi.getTweets();
    return tweetsList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  // function to just get one tweet by it's id
  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetApi.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }

// function for liking a tweet
  void likeTweet(Tweet tweet, UserModel currentUser) async {
    List<String> likes = tweet.likes;
    if (likes.contains(currentUser.uid)) {
      likes.remove(currentUser.uid);
    } else {
      likes.add(currentUser.uid);
    }
    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetApi.likeTweet(tweet);
    res.fold((l) => null, (r) => null);
  }

// Function for Resharing tweets
  void reshareTweet(
    Tweet tweet,
    UserModel currentUser,
    BuildContext context,
  ) async {
    tweet = tweet.copyWith(
      retweetedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: tweet.reshareCount + 1,
    );
    final res = await _tweetApi.updateReshareCount(tweet);

    res.fold(
        (l) => showSnackBar(
              context,
              l.message,
            ), (r) async {
      tweet = tweet.copyWith(
        id: ID.unique(),
        reshareCount: 0,
        tweetedAt: DateTime.now(),
      );
      final res2 = await _tweetApi.shareTweet(tweet);

      return res2.fold((l) {
        return showSnackBar(context, l.message);
      }, (r) {
        return showSnackBar(context, 'Retweeted !');
      });
    });
  }

  // function for getting replies on tweet
  Future<List<Tweet>> getRepliesTo(Tweet tweet) async {
    final documents = await _tweetApi.getRepliesToTweet(tweet);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

// Function for sharing or creating tweets
  void shareTweet({
    required String text,
    required List<File> images,
    required BuildContext context,
    required String repliedTo,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please Write something');
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
      );
    } else {
      _shareTextTweet(text: text, context: context, repliedTo: repliedTo);
    }
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) async {
    state = true;

    final hashtags = _getHashTagsFromText(text);
    String link = _getLinkFromSentence(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageApi.uploadImages(images);

    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _tweetApi.shareTweet(tweet);
    res.fold(
      (l) {
        showSnackBar(context, l.message);
      },
      (r) => showSnackBar(context, 'Tweeted successfully'),
    );
    state = false;
  }

  void _shareTextTweet(
      {required String text,
      required BuildContext context,
      required String repliedTo}) async {
    state = true;
    final hashtags = _getHashTagsFromText(text);
    String link = _getLinkFromSentence(text);
    final user = _ref.read(currentUserDetailsProvider).value!;

    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _tweetApi.shareTweet(tweet);
    res.fold(
      (l) {
        showSnackBar(context, l.message);
      },
      (r) => showSnackBar(context, 'Tweeted successfully'),
    );
    state = false;
  }

  String _getLinkFromSentence(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashTagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
