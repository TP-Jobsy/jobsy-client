import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/util/pallete.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Логотип
            const SizedBox(height: 30),
            SvgPicture.asset('assets/logo.svg', height: 50),
            const SizedBox(height: 70),

            // Иллюстрация
            SvgPicture.asset('assets/onboarding4.svg', height: 250),
            const SizedBox(height: 40),

            // Индикаторы
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(),
                _buildDot(),
                _buildDot(),
                _buildDot(active: true),
              ],
            ),
            const SizedBox(height: 30),

            // Заголовок
            const Text(
              'Надёжные сделки и поддержка 24/7',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),

            // Описание
            const Text(
              'Все платежи проходят через безопасную систему. Вы можете быть уверены в оплате и защите от мошенничества',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Palette.thin, fontFamily: 'Inter'),
            ),
            const Spacer(),

            // Кнопка «Далее» / Начать
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/'); // К экрану регистрации
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Далее', style: TextStyle(color: Palette.white, fontFamily: 'Inter')),

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({bool active = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Palette.primary : Palette.dotInactive,
      ),
    );
  }
}
