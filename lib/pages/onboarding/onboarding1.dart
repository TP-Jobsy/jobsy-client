import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/util/pallete.dart';


class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

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
            SvgPicture.asset('assets/onboarding1.svg', height: 250),
            const SizedBox(height: 40),

            // Индикаторы
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(active: true),
                _buildDot(),
                _buildDot(),
                _buildDot(),
              ],
            ),
            const SizedBox(height: 30),

            // Заголовок
            const Text(
              'Добро пожаловать на Jobsy',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,  fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),

            // Описание
            const Text(
              'Это удобный сервис для поиска фрилансеров и удалённой работы. Размещайте проекты, находите лучших специалистов или зарабатывайте на любимом деле',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Palette.thin, fontFamily: 'Inter'),
            ),
            const Spacer(),

            // Кнопка Далее
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding2');
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

            const SizedBox(height: 12),

            // Кнопка Пропустить
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Palette.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: const BorderSide(color: Palette.dotInactive),
                ),
                child: const Text('Пропустить', style: TextStyle(color: Palette.white, fontFamily: 'Inter')),
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
