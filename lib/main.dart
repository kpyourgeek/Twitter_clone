import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/common/common.dart';
import 'package:the_iconic/controller/auth_controller.dart';
import 'package:the_iconic/features/auth/home/view/home_view.dart';
import 'package:the_iconic/features/auth/view/login_view.dart';
import 'package:the_iconic/theme/splash_screen.dart';
// import 'package:the_iconic/features/auth/view/login_view.dart';
// import 'package:the_iconic/theme/splash_screen.dart';
// import 'package:the_iconic/features/auth/view/signup_view.dart';
import 'package:the_iconic/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
            // you've removed splash screen here because it was causing errors
            // so if you feel like putting it on make sure it won't cause you that bug again
            loading: () => const SplashScreen(),
            data: (user) {
              if (user != null) {
                return const HomeView();
              }
              return const LoginView();
            },
            error: (e, stackTrace) {
              return ErrorPage(error: e.toString());
            },
          ),
    );
  }
}
