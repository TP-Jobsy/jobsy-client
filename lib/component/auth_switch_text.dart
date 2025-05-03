import 'package:flutter/material.dart';
import '../util/palette.dart';

class AuthSwitchText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AuthSwitchText({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(color: Palette.primary, fontFamily: 'Inter'),
      ),
    );
  }
}
