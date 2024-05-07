// PLEASE REMEMBER THIS APPBAR WAS NOT USED CHECK IN YOUR CODES PROPERLY BECAUSE
// YOU HAVE CREATED ANOTHER

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_iconic/constants/assets_constants.dart';
import 'package:the_iconic/features/auth/tweet/widgets/tweet_list.dart';
import 'package:the_iconic/theme/pallete.dart';

class UIConstants {
  // Re-usable appbar for whole applications

  static AppBar appBar() {
    return AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: SvgPicture.asset(
          AssetsConstants.twitterLogo,
          alignment: Alignment.center,
          colorFilter: const ColorFilter.mode(
            Pallete.greenColor,
            BlendMode.srcIn,
          ),
          // color: Pallete.greenColor,
        ));
  }

  static List<Widget> bottomBarPages = [
    const TweetList(),
    const Text('search screen'),
    const Text('notification screen'),
  ];
}
