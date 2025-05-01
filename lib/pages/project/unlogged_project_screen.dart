import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../component/custom_bottom_nav_bar.dart';
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

  static const _projectTabs = ['Открытые', 'В работе', 'Архив'];
  static const _projectAssets = [
    ['assets/projects.svg', 'Открытые проекты', 'Просматривайте доступные задания'],
    ['assets/projects.svg', 'Проекты в работе', 'Следите за прогрессом заданий'],
    ['assets/archive.svg', 'Архив', 'История завершённых проектов'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => setState(() => _bottomNavIndex = i),
      ),
    );
  }

  Widget _buildBody() {
    switch (_bottomNavIndex) {
      case 0:
        return _buildProjects();
      case 1:
        return _buildPlaceholder('Поиск', 'Зарегистрируйтесь, чтобы искать проекты', 'assets/search.svg');
      case 2:
        return _buildPlaceholder('Избранные не доступны', 'Войдите или зарегистрируйтесь, чтобы получить доступ к обсуждениям', 'assets/favorites.svg');
      case 3:
        return _buildPlaceholder('Профиль не доступен', 'Войдите или зарегистрируйтесь, чтобы получить доступ к профилю', 'assets/profile.svg');
      default:
        return const SizedBox();
    }
  }

  Widget _buildProjects() {
    final current = _projectAssets[_tabIndex];
    return Column(
      children: [
        AppBar(
          title: const Text('Проекты', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Palette.white,
          foregroundColor: Palette.black,
          elevation: 0,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Palette.dotInactive,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: List.generate(_projectTabs.length, (i) => _buildTab(_projectTabs[i], i)),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(current[0], height: 260),
                const SizedBox(height: 24),
                Text(
                  current[1],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  current[2],
                  style: const TextStyle(fontSize: 14, color: Palette.thin, fontFamily: 'Inter'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final selected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: selected ? Palette.black : Palette.thin,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String title, String subtitle, String asset) {
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(asset, height: 260),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Palette.thin, fontFamily: 'Inter'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, Routes.auth),
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: const Text('Войти', style: TextStyle(color: Colors.white, fontFamily: 'Inter')),
      ),
    );
  }
}
