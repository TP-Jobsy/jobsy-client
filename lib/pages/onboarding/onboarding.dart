import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/palette.dart';
import '../../util/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  static const _pages = [
    {
      'image': 'assets/onboarding1.svg',
      'title': 'Добро пожаловать на Jobsy',
      'desc':
      'Это удобный сервис для поиска фрилансеров и удалённой работы. '
          'Размещайте проекты, находите лучших специалистов или зарабатывайте на любимом деле.',
    },
    {
      'image': 'assets/onboarding2.svg',
      'title': 'Найдите лучших специалистов',
      'desc':
      'Опишите задачу, получите предложения от фрилансеров и выбирайте лучших специалистов.',
    },
    {
      'image': 'assets/onboarding3.svg',
      'title': 'Размещайте проекты',
      'desc':
      'Создайте профиль, загрузите портфолио и начинайте получать заказы от проверенных клиентов.',
    },
    {
      'image': 'assets/onboarding4.svg',
      'title': 'Заработайте на любимом деле',
      'desc':
      'Получайте новые заказы, растите рейтинг, улучшайте навыки и стройте успешную карьеру на Jobsy.',
    },
  ];

  Future<void> _markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

  Future<void> _next() async {
    if (_page < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 3),
        curve: Curves.easeInOut,
      );
    } else {
      await _markSeen();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.unloggedProjects, (_) => false);
    }
  }

  Future<void> _skip() async {
    await _markSeen();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.unloggedProjects, (_) => false);
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (i) {
        final active = i == _page;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 2),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? Palette.primary : Palette.dotInactive,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // logo…
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    'assets/logo.svg',
                    width: 80,
                    height: 45,
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemCount: _pages.length,
                    itemBuilder: (context, i) {
                      final p = _pages[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            Expanded(
                              child: SvgPicture.asset(
                                p['image']!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildIndicator(),
                            const SizedBox(height: 8),

                            Flexible(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    Text(
                                      p['title']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      p['desc']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Palette.thin,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // bottom buttons…
            Positioned(
              left: 30,
              right: 30,
              bottom: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // "Далее" / "Начать"
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        _page < _pages.length - 1 ? 'Далее' : 'Начать',
                        style: const TextStyle(
                            color: Palette.white, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_page < _pages.length - 1)
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _skip,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Palette.secondary,
                          side: const BorderSide(color: Palette.dotInactive),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Пропустить',
                          style: TextStyle(
                              color: Palette.white, fontFamily: 'Inter'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}