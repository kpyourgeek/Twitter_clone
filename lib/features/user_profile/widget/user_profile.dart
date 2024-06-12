import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/common/common.dart';
import 'package:the_iconic/constants/appwrite/appwrite_constants.dart';
import 'package:the_iconic/controller/auth_controller.dart';
import 'package:the_iconic/features/auth/tweet/controller/tweet_controller.dart';
import 'package:the_iconic/features/auth/tweet/widgets/tweet_card.dart';
import 'package:the_iconic/features/user_profile/controller/user_profille_controller.dart';
import 'package:the_iconic/features/user_profile/view/edit_profile_view.dart';
import 'package:the_iconic/features/user_profile/widget/follow_count.dart';
import 'package:the_iconic/models/tweet_model.dart';
import 'package:the_iconic/models/user_model.dart';
import 'package:the_iconic/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: user.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.greenColor,
                              )
                            : Image.network(
                                user.bannerPic,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 40,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {
                            if (currentUser.uid == user.uid) {
                              Navigator.push(context, EditProfileView.route());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide(
                                  color: Pallete.whiteColor, width: 2),
                            ),
                          ),
                          child: Text(
                            currentUser.uid == user.uid
                                ? 'Edit Profile'
                                : 'Follow',
                            style: const TextStyle(color: Pallete.whiteColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Pallete.greyColor,
                          ),
                        ),
                        Text(
                          user.bio,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            FollowCount(
                                count: user.followers.length,
                                text: 'followers'),
                            const SizedBox(width: 18),
                            FollowCount(
                                count: user.following.length, text: 'following')
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Divider(color: Pallete.whiteColor),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: ref.watch(getUserTweetsProvider(user.uid)).when(
                  data: (tweets) {
                    ref.watch(getUserLatestTweetProvider).when(
                          data: (data) {
                            if (data.events.contains(
                                'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create')) {
                              tweets.insert(0, Tweet.fromMap(data.payload));
                            }
                          },
                          error: (error, st) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        );
                    return ListView.builder(
                        itemCount: tweets.length,
                        itemBuilder: (context, index) {
                          final tweet = tweets[index];
                          return TweetCard(tweet: tweet);
                        });
                  },
                  error: (error, st) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          );
  }
}
