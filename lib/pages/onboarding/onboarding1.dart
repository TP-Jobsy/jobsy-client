import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/util/pallete.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onNext() {
    if (_currentPage < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      Navigator.pushNamed(context, '/onboarding2');
    }
  }

  void _onSkip() {
    Navigator.pushReplacementNamed(context, '/');
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
            const SizedBox(height: 30),
            SvgPicture.asset('assets/logo.svg', height: 50),
            const SizedBox(height: 70),

            // PageView for onboarding screens
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  // 1st Onboarding Screen
                  _buildOnboardingPage(
                    'Добро пожаловать на Jobsy',
                    'Это удобный сервис для поиска фрилансеров и удалённой работы. Размещайте проекты, находите лучших специалистов или зарабатывайте на любимом деле',
                    'assets/onboarding1.svg',
                  ),
                  // 2nd Onboarding Screen (Repeat as needed)
                  _buildOnboardingPage(
                    'Найдите лучших специалистов',
                    'Подберите фрилансера, который идеально подходит для вашего проекта, и начните работу!',
                    'assets/onboarding2.svg',
                  ),
                  // 3rd Onboarding Screen (Repeat as needed)
                  _buildOnboardingPage(
                    'Размещайте проекты',
                    'Легко публикуйте ваши проекты и находите исполнителей для различных задач.',
                    'assets/onboarding3.svg',
                  ),
                  // 4th Onboarding Screen (Repeat as needed)
                  _buildOnboardingPage(
                    'Заработайте на любимом деле',
                    'Предлагайте свои услуги и зарабатывайте, работая удаленно.',
                    'assets/onboarding4.svg',
                  ),
                ],
              ),
            ),

            // Индикаторы
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => _buildDot(index == _currentPage)),
            ),
            const SizedBox(height: 30),

            // Кнопка Далее
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onNext,
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
                onPressed: _onSkip,
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

  Widget _buildOnboardingPage(String title, String description, String imagePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(imagePath, height: 250),
        const SizedBox(height: 40),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Palette.thin, fontFamily: 'Inter'),
        ),
      ],
    );
  }

  Widget _buildDot(bool active) {
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
