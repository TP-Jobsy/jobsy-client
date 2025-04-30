import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/util/pallete.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/routes.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  Future<void> _markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

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
              'Карьерный рост',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),

            // Описание
            const Text(
              'Получайте новые заказы, растите рейтинг, улучшайте навыки и стройте успешную карьеру на Jobsy.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Palette.thin, fontFamily: 'Inter'),
            ),
            const Spacer(),

            // Кнопка «Далее» / Начать
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await _markOnboardingSeen();
                  Navigator.pushReplacementNamed(context, Routes.auth); // К экрану регистрации
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
