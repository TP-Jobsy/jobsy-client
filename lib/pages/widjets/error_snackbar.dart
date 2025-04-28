import 'package:flutter/material.dart';
import '../../util/pallete.dart';

class ErrorSnackbar {
  static void show(
      BuildContext context, {
        required String title,
        String message = 'Пожалуйста повторите попытку позже',
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Palette.red.withOpacity(0.2),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Palette.red),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Palette.red),
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
          ],
        ),
      ),
    );
  }
}
