import 'package:flutter/material.dart';
import 'package:the_iconic/theme/theme.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  // my Constructor

  const RoundedSmallButton(
      {super.key,
      required this.onTap,
      required this.label,
      this.backgroundColor = Pallete.greenColor,
      this.textColor = Pallete.blackColor});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }
}
