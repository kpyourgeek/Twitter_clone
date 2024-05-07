import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/common/common.dart';
import 'package:the_iconic/features/auth/tweet/controller/tweet_controller.dart';
import 'package:the_iconic/features/auth/tweet/widgets/tweet_card.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
        data: (tweets) => ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (BuildContext context, index) {
                final tweet = tweets[index];
                return TweetCard(tweet: tweet);
              },
            ),
        error: (error, stackTrace) => ErrorPage(
              error: error.toString(),
            ),
        loading: () => const Loader());
  }
}
