import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_iconic/theme/pallete.dart';

@immutable
class TweeetIconButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  const TweeetIconButton(
      {super.key,
      required this.iconPath,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            colorFilter: const ColorFilter.mode(
              Pallete.greyColor,
              BlendMode.srcIn,
            ),
          ),
          Container(
              margin: const EdgeInsets.all(6),
              child: Text(
                label,
                style: const TextStyle(
                  color: Pallete.greyColor,
                ),
              )),
        ],
      ),
    );
  }
}
