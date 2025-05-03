import 'package:flutter/material.dart';

import '../util/palette.dart';

enum ErrorType { info, success, warning, error }

class ErrorSnackbar {
  static void show(
      BuildContext context, {
        required ErrorType type,
        required String title,
        required String message,
      }) {
    final colors = _getColors(type);

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 100,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 4),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: colors['background'],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors['iconBackground'],
                shape: BoxShape.circle,
              ),
              child: Icon(
                colors['icon'],
                color: Palette.white,
                size: 16,
              ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      color: Palette.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Palette.thin,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: const Icon(Icons.close, color: Palette.black1),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Map<String, dynamic> _getColors(ErrorType type) {
    switch (type) {
      case ErrorType.info:
        return {
          'background': Palette.blue2,
          'iconBackground': Palette.blue1, // Синий
          'icon': Icons.info_outline,
        };
      case ErrorType.success:
        return {
          'background': Palette.green1,
          'iconBackground': Palette.green, // Зеленый
          'icon': Icons.check,
        };
      case ErrorType.warning:
        return {
          'background': Palette.milk1,
          'iconBackground': Palette.orange, // Оранжевый
          'icon': Icons.error_outline,
        };
      case ErrorType.error:
        return {
          'background': Palette.milk,
          'iconBackground': Palette.bloodred, // Красный
          'icon': Icons.error,
        };
    }
  }
}