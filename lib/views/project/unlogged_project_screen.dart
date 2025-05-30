import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../component/custom_bottom_nav_bar.dart';
import '../../component/custom_nav_bar.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';

class UnloggedScreen extends StatefulWidget {
  const UnloggedScreen({super.key});

  @override
  State<UnloggedScreen> createState() => _UnloggedScreenState();
}

class _UnloggedScreenState extends State<UnloggedScreen> {
  int _bottomNavIndex = 0;
  int _tabIndex = 0;
  final PageController _pageController = PageController();

  static const _projectTabs = ['Открытые', 'В работе', 'Архив'];
  static const _projectAssets = [
    ['assets/unlog.svg', 'Открытые проекты', 'Просматривайте доступные задания'],
    ['assets/unlog.svg', 'Проекты в работе', 'Следите за прогрессом заданий'],
    ['assets/unlog.svg', 'Архив', 'История завершённых проектов'],
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Palette.white,
      body: _buildBody(isSmallScreen, screenHeight, screenWidth),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => setState(() => _bottomNavIndex = i),
      ),
    );
  }

  Widget _buildBody(bool isSmallScreen, double screenHeight, double screenWidth) {
    switch (_bottomNavIndex) {
      case 0:
        return _buildProjects(isSmallScreen, screenHeight, screenWidth);
      case 1:
        return _buildPlaceholder(
          'Поиск',
          'Зарегистрируйтесь, чтобы искать проекты',
          'assets/unlog.svg',
          isSmallScreen,
          screenHeight,
        );
      case 2:
        return _buildPlaceholder(
          'Избранные не доступны',
          'Войдите или зарегистрируйтесь, чтобы получить доступ к обсуждениям',
          'assets/unlog.svg',
          isSmallScreen,
          screenHeight,
        );
      case 3:
        return _buildPlaceholder(
          'Профиль не доступен',
          'Войдите или зарегистрируйтесь, чтобы получить доступ к профилю',
          'assets/unlog.svg',
          isSmallScreen,
          screenHeight,
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildProjects(bool isSmallScreen, double screenHeight, double screenWidth) {
    return Column(
      children: [
        CustomNavBar(
          leading: const SizedBox(width: 20),
          title: 'Проекты',
          titleStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Palette.black,
            fontFamily: 'Inter',
          ),
          trailing: const SizedBox(),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth < 360 ? 12 : 16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Palette.dotInactive,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: List.generate(
                _projectTabs.length,
                    (i) => _buildTab(_projectTabs[i], i, screenWidth),
              ),
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 16 : 24),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _projectAssets.length,
            onPageChanged: (index) => setState(() => _tabIndex = index),
            itemBuilder: (context, index) {
              final current = _projectAssets[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 360 ? 16 : 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      current[0],
                      height: isSmallScreen ? screenHeight * 0.3 : 400,
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),
                    Text(
                      current[1],
                      style: TextStyle(
                        fontSize: screenWidth < 360 ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    Text(
                      current[2],
                      style: TextStyle(
                        fontSize: screenWidth < 360 ? 12 : 14,
                        color: Palette.thin,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isSmallScreen ? 24 : 36),
                    _buildLoginButton(screenWidth),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int index, double screenWidth) {
    final selected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 3),
            curve: Curves.easeInOut,
          );
          setState(() => _tabIndex = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Palette.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.all(4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth < 360 ? 12 : 14,
              fontWeight: FontWeight.bold,
              color: selected ? Palette.black : Palette.thin,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(
      String title,
      String subtitle,
      String asset,
      bool isSmallScreen,
      double screenHeight,
      ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        AppBar(
          title: const Text('Неавторизованный', style: TextStyle(fontFamily: 'Inter')),
          backgroundColor: Palette.white,
          foregroundColor: Palette.black,
          centerTitle: true,
          elevation: 0,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 360 ? 16 : 24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  asset,
                  height: isSmallScreen ? screenHeight * 0.25 : 260,
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth < 360 ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenWidth < 360 ? 12 : 14,
                    color: Palette.thin,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmallScreen ? 24 : 36),
                _buildLoginButton(screenWidth),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(double screenWidth) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, Routes.auth),
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              screenWidth < 360 ? 16 : 24,
            ),
          ),
        ),
        child: const Text(
          'Войти',
          style: TextStyle(color: Palette.white, fontFamily: 'Inter'),
        ),
      ),
    );
  }
}