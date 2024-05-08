import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:the_iconic/common/common.dart';
import 'package:the_iconic/constants/assets_constants.dart';
import 'package:the_iconic/controller/auth_controller.dart';
import 'package:the_iconic/core/enums/tweet_type_enum.dart';
import 'package:the_iconic/features/auth/tweet/controller/tweet_controller.dart';
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
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
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
                              if (tweet.retweetedBy.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AssetsConstants.retweetIcon,
                                      colorFilter: const ColorFilter.mode(
                                        Pallete.greyColor,
                                        BlendMode.srcIn,
                                      ),
                                      height: 20,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${tweet.retweetedBy} has retweeted  ',
                                      style: const TextStyle(
                                          color: Pallete.greyColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
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
                                margin:
                                    const EdgeInsets.only(top: 10, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      onTap: () {
                                        ref
                                            .read(tweetControllerProvider
                                                .notifier)
                                            .reshareTweet(
                                              tweet,
                                              currentUser,
                                              context,
                                            );
                                      },
                                    ),
                                    LikeButton(
                                      onTap: (isLiked) async {
                                        ref
                                            .read(tweetControllerProvider
                                                .notifier)
                                            .likeTweet(tweet, currentUser);
                                        return isLiked;
                                      },
                                      size: 25,
                                      isLiked:
                                          tweet.likes.contains(currentUser.uid),
                                      likeBuilder: (isLiked) {
                                        return isLiked
                                            ? SvgPicture.asset(
                                                AssetsConstants.likeFilledIcon,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Pallete.redColor,
                                                  BlendMode.srcIn,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                AssetsConstants
                                                    .likeOutlinedIcon,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Pallete.greyColor,
                                                  BlendMode.srcIn,
                                                ),
                                              );
                                      },
                                      likeCount: tweet.likes.length,
                                      countBuilder: (count, isLiked, text) {
                                        return Text(
                                          text,
                                          style: TextStyle(
                                            color: isLiked
                                                ? Pallete.redColor
                                                : Pallete.greyColor,
                                            fontSize: 16,
                                          ),
                                        );
                                      },
                                    ),

                                    // TweeetIconButton(
                                    //   iconPath: AssetsConstants.likeOutlinedIcon,
                                    //   label: tweet.likes.length.toString(),
                                    //   onTap: () {},
                                    // ),
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
