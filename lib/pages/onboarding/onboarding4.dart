import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            const SizedBox(height: 30),

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Описание
            const Text(
              'Все платежи проходят через безопасную систему. Вы можете быть уверены в оплате и защите от мошенничества',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
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
                  backgroundColor:   const Color(0xFF2842F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Далее', style: TextStyle(color: Colors.white)),

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
        color: active ? Colors.blue : Colors.grey.shade300,
      ),
    );
  }
}
