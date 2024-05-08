import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_iconic/common/loading_page.dart';
import 'package:the_iconic/constants/constants.dart';
import 'package:the_iconic/controller/auth_controller.dart';
import 'package:the_iconic/core/utilis.dart';
import 'package:the_iconic/features/auth/tweet/controller/tweet_controller.dart';
import 'package:the_iconic/theme/pallete.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateTweetScreen(),
      );
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  // controller for my words to go with tweet
  final textTweetcontroller = TextEditingController();

  // variable for showing Images on the screen
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    textTweetcontroller.dispose();
  }

  void onShareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
          text: textTweetcontroller.text,
          images: images,
          context: context,
        );
    textTweetcontroller.clear();
  }

// function for picking Images from gallery
  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentUser.profilePic),
                            radius: 30,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: textTweetcontroller,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            decoration: const InputDecoration(
                                hintText: "What's happening?",
                                hintStyle: TextStyle(
                                  color: Pallete.greyColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none),
                            maxLines: null,
                          ),
                        )
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map(
                          (file) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Image.file(file),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Pallete.greyColor,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
                child: GestureDetector(
                  onTap: onPickImages,
                  child: SvgPicture.asset(
                    AssetsConstants.galleryIcon,
                    colorFilter: const ColorFilter.mode(
                      Pallete.greenColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
                child: SvgPicture.asset(
                  AssetsConstants.gifIcon,
                  colorFilter: const ColorFilter.mode(
                    Pallete.greenColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
                child: SvgPicture.asset(
                  AssetsConstants.emojiIcon,
                  colorFilter: const ColorFilter.mode(
                    Pallete.greenColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onShareTweet,
        child: const Icon(
          Icons.send,
          color: Pallete.blackColor,
        ),
      ),
    );
  }
}
