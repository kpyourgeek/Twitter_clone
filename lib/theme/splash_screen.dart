import 'package:flutter/material.dart';
import 'package:the_iconic/features/auth/view/signup_view.dart';
import 'package:the_iconic/theme/pallete.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SignupView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Pallete.blackColor,
        body: Center(
          child: Text(
            'Iconic',
            style: TextStyle(
              fontSize: 50,
              fontFamily: 'Rubik',
              color: Pallete.greenColor,
            ),
          ),
        ));
  }
}
