import 'package:flutter/material.dart';
import '../../../util/palette.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset('assets/logo_text_blue.png', height: 40),
            const SizedBox(height: 32),

            Image.asset('assets/images/404_illustration.png', height: 200),

            const SizedBox(height: 32),

            const Text(
              'Ошибка 404\nСтраница не найдена',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Palette.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Произошла ошибка',
              style: TextStyle(
                fontSize: 14,
                color: Palette.thin,
                fontFamily: 'Inter',
              ),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Вернуться обратно',
                  style: TextStyle(
                    color: Palette.white,
                    fontFamily: 'Inter',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
