import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/palette.dart';

class CustomNavBar extends StatelessWidget {
  final Widget? leading;
  final String title;
  final TextStyle? titleStyle;
  final Widget? trailing;

  const CustomNavBar({
    super.key,
    this.leading,
    required this.title,
    this.titleStyle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final Widget leadingWidget = leading ??
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/ArrowLeft.svg',
              width: 24,
              height: 24,
              color: Palette.black,
            ),
          ),
        );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
        child: Row(
          children: [
            leadingWidget,
            const Spacer(),
            Text(
              title,
              style: titleStyle ??
                  const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Palette.black,
                    fontFamily: 'Inter',
                  ),
            ),
            const Spacer(),
            trailing ?? const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}