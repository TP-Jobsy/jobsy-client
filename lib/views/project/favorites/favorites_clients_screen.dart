import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jobsy/component/error_snackbar.dart';
import 'package:jobsy/service/favorite_service.dart';
import 'package:jobsy/util/palette.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Добавлено для SVG
import '../../../component/custom_bottom_nav_bar.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../component/favorites_card_client_model.dart';
import '../../../model/project/project.dart';
import '../../../util/routes.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late FavoriteService _favService;
  List<Project> _favorites = [];
  bool _loading = true;
  String? _error;
  int _currentNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _favService = context.read<FavoriteService>();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final list = await _favService.fetchFavoriteProjects();
      setState(() {
        _favorites = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadAllData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    await _loadFavorites();
  }

  void _onNavTap(int idx) {
    if (idx == _currentNavIndex) return;
    setState(() => _currentNavIndex = idx);
    switch (idx) {
      case 0:
        Navigator.pushReplacementNamed(context, Routes.projectsFree);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, Routes.searchProject);
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, Routes.profileFree);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    final fontSizeTitle = isSmallScreen ? 18.0 : 20.0;
    final paddingVertical = isSmallScreen ? 6.0 : 8.0;
    final maxCardWidth = screenWidth < 500 ? screenWidth - 32 : 420.0;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomNavBar(
          leading: const SizedBox(width: 20),
          title: 'Избранное',
          titleStyle: TextStyle(
            fontSize: fontSizeTitle,
            fontWeight: FontWeight.w700,
            color: Palette.black,
            fontFamily: 'Inter',
          ),
          trailing: const SizedBox(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Ошибка: $_error',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Palette.red,
            ),
          ),
        ),
      )
          : _favorites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/OBJECTS.svg',
              width: screenWidth * 0.8,
              height: screenWidth * 0.8,
            ),
            const SizedBox(height: 25),
            Text(
              'У вас нет избранных проектов',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 18,
                color: Palette.grey3,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: 16,
        ),
        itemCount: _favorites.length,
        itemBuilder: (ctx, i) {
          final p = _favorites[i];
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxCardWidth),
              child: FavoritesCardClientModel(
                project: p,
                isFavorite: true,
                onFavoriteToggle: () async {
                  try {
                    await _favService.removeFavoriteProject(p.id);
                    setState(() => _favorites.removeAt(i));
                  } catch (e) {
                    ErrorSnackbar.show(
                      context,
                      type: ErrorType.error,
                      title: 'Ошибка удаления',
                      message: e.toString(),
                    );
                  }
                },
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.projectDetailFree,
                    arguments: p.toJson(),
                  ).then((_) => _loadAllData());
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}