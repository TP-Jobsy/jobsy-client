import 'package:flutter/material.dart';
import '../../../component/custom_bottom_nav_bar.dart';
import '../../../component/favorites_card.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _bottomNavIndex = 2;

  List<Map<String, dynamic>> _favoriteProjects = [
    {
      'title': 'Разработка мобильного приложения',
      'fixedPrice': 150000.0,
      'complexity': 'MEDIUM',
      'duration': 'LESS_THAN_3_MONTHS',
      'clientCompany': 'ООО "ТехноПро"',
      'clientLocation': 'Москва',
      'createdAt': '2023-10-15T10:30:00Z',
      'isFavorite': true,
    },
    {
      'title': 'Дизайн лендинга',
      'fixedPrice': 50000.0,
      'complexity': 'EASY',
      'duration': 'LESS_THAN_1_MONTH',
      'clientCompany': 'ИП Иванов',
      'clientLocation': 'Санкт-Петербург',
      'createdAt': '2023-11-02T14:45:00Z',
      'isFavorite': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Избранные', style: TextStyle(fontFamily: 'Inter')),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _buildFavoritesContent(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => _handleNavigationTap(i, context),
      ),
    );
  }

  void _handleNavigationTap(int index, BuildContext context) async {
    if (index == _bottomNavIndex) return;

    if (index == 0) {
      setState(() => _bottomNavIndex = 0);
      await Navigator.pushNamed(context, Routes.projects);
    } else if (index == 1) {
      setState(() => _bottomNavIndex = 1);
      await Navigator.pushNamed(context, Routes.searchProject);
    } else if (index == 3) {
      await Navigator.pushNamed(context, Routes.profileFree);
      setState(() => _bottomNavIndex = 3);
    }
  }

  Widget _buildFavoritesContent() {
    if (_favoriteProjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              'У вас пока нет избранных проектов',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавляйте проекты в избранное, чтобы они отображались здесь',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoriteProjects.length,
      itemBuilder: (context, index) {
        return ProjectCard(
          project: _favoriteProjects[index],
          onFavoriteToggle: () {
            setState(() {
              _favoriteProjects.removeAt(index);
            });
          },
        );
      },
    );
  }
}
