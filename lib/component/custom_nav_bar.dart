// lib/widgets/custom_nav_bar.dart
import 'package:flutter/material.dart';

/// Плоский nav bar:
/// - SafeArea + отступ сверху 50px
/// - горизонтальные отступы 24px
/// - просто Row(leading, Spacer, title, Spacer, trailing)
class CustomNavBar extends StatelessWidget {
  /// Левый виджет (например стрелка «назад»).
  final Widget? leading;

  /// Центральный заголовок.
  final String title;

  /// Правый виджет (например крестик) или null.
  final Widget? trailing;

  const CustomNavBar({
    Key? key,
    this.leading,
    required this.title,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // отступ сверху 50px
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              // слева — иконка или пустой SizedBox нужной ширины
              leading ?? const SizedBox(width: 24),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              // справа — ваш виджет или пустой SizedBox
              trailing ?? const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }
}