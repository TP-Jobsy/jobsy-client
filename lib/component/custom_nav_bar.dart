import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/palette.dart';

/// Плоский nav bar:
/// - SafeArea + отступ сверху 30px
/// - горизонтальные отступы 24px
/// - Row(leading, Spacer, title, Spacer, trailing)
class CustomNavBar extends StatelessWidget {
  /// Если не передан — слева будет стандартная стрелка назад из assets/icons/ArrowLeft.svg
  final Widget? leading;

  /// Заголовок
  final String title;

  /// Стиль текста заголовка. Если null — берётся дефолт 18px, w400.
  final TextStyle? titleStyle;

  /// Виджет справа или пустышка
  final Widget? trailing;

  const CustomNavBar({
    Key? key,
    this.leading,
    required this.title,
    this.titleStyle,
    this.trailing,
  }) : super(key: key);

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
        padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
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