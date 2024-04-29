import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/common/loading_page.dart';
import 'package:the_iconic/constants/ui_constants.dart';
import 'package:the_iconic/controller/auth_controller.dart';
import 'package:the_iconic/features/auth/view/signup_view.dart';
import 'package:the_iconic/features/auth/widgets/auth_field.dart';
import 'package:the_iconic/theme/pallete.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  // for preventing always to call build method when app is opened
  final appbar = UIConstants.appBar();

  // calling text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // disposing off controllers when they are no longer needed
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  onLogin() {
    ref.read(authControllerProvider.notifier).logIn(
        email: emailController.text.trim(),
        password: passwordController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isSubmitting
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // email textfield
                      AuthField(
                        controller: emailController,
                        hintText: 'Email',
                      ),

                      const SizedBox(height: 25),

                      // password textfield
                      AuthField(
                        controller: passwordController,
                        hintText: 'Password',
                      ),
                      const SizedBox(height: 40),

                      // button
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: onLogin,
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Pallete.greenColor),
                            )),
                      ),

                      const SizedBox(height: 40),

                      //text span
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account?",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                                text: ' Sign up',
                                style: const TextStyle(
                                  color: Pallete.greenColor,
                                  fontSize: 16,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      SignupView.route(),
                                    );
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
