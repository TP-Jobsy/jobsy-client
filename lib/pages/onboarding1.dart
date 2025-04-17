import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Логотип
            Image.asset('assets/logo.png', height: 40),
            const SizedBox(height: 30),

            // Иллюстрация
            Image.asset('assets/onboarding1.png', height: 250), 
            const SizedBox(height: 30),

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Описание
            const Text(
              'Это удобный сервис для поиска фрилансеров и удалённой работы. Размещайте проекты, находите лучших специалистов или зарабатывайте на любимом деле',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
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
                  backgroundColor:   const Color(0xFF2842F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Далее', style: TextStyle(color: Colors.white)),

                
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
                    backgroundColor:   const Color(0xFF8F9098),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
                child: const Text('Пропустить', style: TextStyle(color: Colors.white)),
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
