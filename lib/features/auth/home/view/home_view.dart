import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_iconic/constants/constants.dart';
import 'package:the_iconic/constants/ui_constants.dart';
import 'package:the_iconic/features/auth/tweet/views/create_tweet_view.dart';
import 'package:the_iconic/theme/pallete.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final appBar = UIConstants.appBar();

  int _page = 0;
  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  void onCreateTweet() {
    Navigator.push(context, CreateTweetScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onCreateTweet();
        },
        child: const Icon(
          Icons.add,
          color: Pallete.blackColor,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConstants.homeFilledIcon
                  : AssetsConstants.homeOutlinedIcon,
              colorFilter: const ColorFilter.mode(
                Pallete.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              colorFilter: const ColorFilter.mode(
                Pallete.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              colorFilter: const ColorFilter.mode(
                Pallete.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:the_iconic/constants/ui_constants.dart';
// import 'package:the_iconic/controller/auth_controller.dart';

// class HomeView extends ConsumerStatefulWidget {
//   static Route route() => MaterialPageRoute(
//         builder: (context) => const HomeView(),
//       );
//   const HomeView({super.key});

//   @override
//   ConsumerState<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends ConsumerState<HomeView> {
//   onLogOut() {
//     ref.read(authControllerProvider.notifier).logOut(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: UIConstants.appBar(),
//         body: Center(
//           child:
//               ElevatedButton(onPressed: onLogOut, child: const Text('Logout')),
//         ));
//   }
// }
