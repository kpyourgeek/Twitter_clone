import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/apis/storage_api.dart';
import 'package:the_iconic/apis/tweet_api.dart';
import 'package:the_iconic/controller/auth_controller.dart';
import 'package:the_iconic/core/enums/tweet_type_enum.dart';
import 'package:the_iconic/core/utilis.dart';
import 'package:the_iconic/models/tweet_model.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    final tweetApi = ref.watch(tweetApiProvider);
    final storageApi = ref.watch(storageApiProvider);
    return TweetController(
        ref: ref, tweetApi: tweetApi, storageApi: storageApi);
  },
);

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

  void shareTweet({
    required String text,
    required List<File> images,
    required BuildContext context,
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
      );
    } else {
      _shareTextTweet(
        text: text,
        context: context,
      );
    }
  }

  void _shareImageTweet(
      {required List<File> images,
      required String text,
      required BuildContext context}) async {
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
      repliedTo: '',
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

  void _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
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
      repliedTo: '',
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