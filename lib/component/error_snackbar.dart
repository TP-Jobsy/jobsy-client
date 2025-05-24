import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../util/palette.dart';

enum ErrorType { info, success, warning, error }

class ErrorSnackbar {
  static void show(
    BuildContext context, {
    required ErrorType type,
    required String title,
    required String message,
  }) {
    final cfg = _getConfig(type);

    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 120),
      duration: const Duration(seconds: 4),
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cfg.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cfg.iconBackground,
                shape: BoxShape.circle,
              ),
              child: cfg.iconWidget,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Palette.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Palette.thin,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: SvgPicture.asset(
                'assets/icons/Close.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Palette.grey1,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static _SnackbarConfig _getConfig(ErrorType type) {
    switch (type) {
      case ErrorType.info:
        return _SnackbarConfig(
          background: Palette.blue1.withOpacity(0.2),
          iconBackground: Palette.blue1,
          iconWidget: SvgPicture.asset(
            'assets/icons/Info.svg',
            width: 24,
            height: 24,
          ),
        );
      case ErrorType.success:
        return _SnackbarConfig(
          background: Palette.green.withOpacity(0.2),
          iconBackground: Palette.green,
          iconWidget: SvgPicture.asset(
            'assets/icons/Success.svg',
            width: 24,
            height: 24,
          ),
        );
      case ErrorType.warning:
        return _SnackbarConfig(
          background: Palette.orange.withOpacity(0.3),
          iconBackground: Palette.orange,
          iconWidget: SvgPicture.asset(
            'assets/icons/Warning.svg',
            width: 24,
            height: 24,
          ),
        );
      case ErrorType.error:
        return _SnackbarConfig(
          background: Palette.red.withOpacity(0.3),
          iconBackground: Palette.red.withOpacity(1),
          iconWidget: SvgPicture.asset(
            'assets/icons/Warning.svg',
            width: 24,
            height: 24,
          ),
        );
    }
  }
}

class _SnackbarConfig {
  final Color background;
  final Color iconBackground;
  final Widget iconWidget;

  _SnackbarConfig({
    required this.background,
    required this.iconBackground,
    required this.iconWidget,
  });
}
