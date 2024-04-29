// very good way to use common textfield if needed take a deep look please

import 'package:flutter/material.dart';
import 'package:the_iconic/theme/pallete.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const AuthField(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // decorating textfield

      // when textfield is clicked on this is it's decoration
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  const BorderSide(color: Pallete.greenColor, width: 3)),
          // when text field is not clicked on that is it's textfield
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  const BorderSide(color: Pallete.greenColor, width: 1)),
          contentPadding: const EdgeInsets.all(22),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 18)),
    );
  }
}
