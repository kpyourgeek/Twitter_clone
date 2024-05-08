import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/common/common.dart';
import 'package:the_iconic/constants/appwrite/appwrite_constants.dart';
import 'package:the_iconic/features/auth/tweet/controller/tweet_controller.dart';
import 'package:the_iconic/features/auth/tweet/widgets/tweet_card.dart';
import 'package:the_iconic/models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
        data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
                data: (data) {
                  if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create')) {
                    tweets.insert(0, Tweet.fromMap(data.payload));
                  } else if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update')) {
                    // id of tweet retweeted
                    final startingPoint =
                        data.events[0].lastIndexOf('documents.');
                    final endingPoint = data.events[0].lastIndexOf('.update');
                    final tweetId = data.events[0]
                        .substring(startingPoint + 10, endingPoint);
                    // getting the retweed tweet ,
                    // we used .first because we know it's first tweeted retrieved to be replaced
                    var tweet = tweets.where((element) {
                      return element.id == tweetId;
                    }).first;
                    // getting tweet index
                    final tweetIndex = tweets.indexOf(tweet);
                    // replacing tweet by first removing existing one and then adding new one
                    tweets.removeWhere((element) => element.id == tweetId);
                    // adding new
                    tweet = Tweet.fromMap(data.payload);
                    tweets.insert(tweetIndex, tweet);
                  }
                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    },
                  );
                },
                error: (error, stackTrace) =>
                    ErrorPage(error: error.toString()),
                loading: () {
                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    },
                  );
                },
              );
        },
        error: (error, stackTrace) => ErrorPage(
              error: error.toString(),
            ),
        loading: () => const Loader());
  }
}
