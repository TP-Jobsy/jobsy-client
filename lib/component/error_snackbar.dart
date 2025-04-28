import 'package:flutter/material.dart';

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
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 4), // Автоматически закрывается через 4 сек
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
                color: Colors.white,
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
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: const Icon(Icons.close, color: Colors.black45),
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
          'background': const Color(0xFFEAF3FF),
          'iconBackground': Color(0xFF007BFF), // Синий
          'icon': Icons.info_outline,
        };
      case ErrorType.success:
        return {
          'background': const Color(0xFFE9F7EC),
          'iconBackground': Color(0xFF28A745), // Зеленый
          'icon': Icons.check,
        };
      case ErrorType.warning:
        return {
          'background': const Color(0xFFFFF5E5),
          'iconBackground': Color(0xFFFFC107), // Оранжевый
          'icon': Icons.error_outline,
        };
      case ErrorType.error:
        return {
          'background': const Color(0xFFFFE9E9),
          'iconBackground': Color(0xFFDC3545), // Красный
          'icon': Icons.error,
        };
    }
  }
}
