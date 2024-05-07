import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/common/common.dart';
import 'package:the_iconic/constants/assets_constants.dart';
import 'package:the_iconic/controller/auth_controller.dart';
import 'package:the_iconic/core/enums/tweet_type_enum.dart';
import 'package:the_iconic/features/auth/tweet/widgets/caraousel_image.dart';
import 'package:the_iconic/features/auth/tweet/widgets/hashtag_text.dart';
import 'package:the_iconic/features/auth/tweet/widgets/tweet_icon_button.dart';
import 'package:the_iconic/models/tweet_model.dart';
import 'package:the_iconic/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(tweet.uid)).when(
          data: (user) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ******Rweeted****
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                '@${user.name} . ${timeago.format(
                                  tweet.tweetedAt,
                                  locale: 'en_short',
                                )}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Pallete.greyColor,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          //***** Replied to */
                          HashtagText(text: tweet.text),
                          if (tweet.tweetType == TweetType.image)
                            CaraouselImage(imageLinks: tweet.imageLinks),
                          if (tweet.link.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            AnyLinkPreview(
                              backgroundColor: Pallete.greyColor,
                              borderRadius: 12,
                              showMultimedia: true,
                              link: 'https://${tweet.link}',
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                            ),
                          ],
                          Container(
                            margin: const EdgeInsets.only(top: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TweeetIconButton(
                                  iconPath: AssetsConstants.viewsIcon,
                                  label: (tweet.commentIds.length +
                                          tweet.reshareCount +
                                          tweet.likes.length)
                                      .toString(),
                                  onTap: () {},
                                ),
                                TweeetIconButton(
                                  iconPath: AssetsConstants.commentIcon,
                                  label: tweet.commentIds.length.toString(),
                                  onTap: () {},
                                ),
                                TweeetIconButton(
                                  iconPath: AssetsConstants.retweetIcon,
                                  label: tweet.reshareCount.toString(),
                                  onTap: () {},
                                ),
                                TweeetIconButton(
                                  iconPath: AssetsConstants.likeOutlinedIcon,
                                  label: tweet.likes.length.toString(),
                                  onTap: () {},
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    color: Pallete.greyColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 1),
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: Pallete.greyColor,
                ),
              ],
            );
          },
          error: (error, stackTrace) => ErrorPage(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}