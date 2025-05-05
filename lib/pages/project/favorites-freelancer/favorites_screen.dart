import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jobsy/component/error_snackbar.dart';
import 'package:jobsy/component/favorites_card_client.dart';
import 'package:jobsy/provider/auth_provider.dart';
import 'package:jobsy/service/favorite_service.dart';
import 'package:jobsy/util/palette.dart';
import '../../../component/custom_bottom_nav_bar.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../model/project/project.dart';
import '../../../util/routes.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late FavoriteService _favService;
  late String _token;
  List<Project> _favorites = [];
  bool _loading = true;
  String? _error;
  int _currentNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _favService = context.read<FavoriteService>();
    _token = context.read<AuthProvider>().token ?? '';
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final list = await _favService.fetchFavoriteProjects(_token);
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
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomNavBar(
          leading: const SizedBox(),
          title: 'Избранное',
          titleStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Palette.black,
            fontFamily: 'Inter',
          ),
          trailing: const SizedBox(),
        ),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text('Ошибка: $_error'))
              : _favorites.isEmpty
              ? Center(
                child: Text(
                  'У вас нет избранных проектов',
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _favorites.length,
                itemBuilder: (ctx, i) {
                  final p = _favorites[i];
                  return FavoritesCardClient(
                    project: p,
                    isFavorite: true,
                    onFavoriteToggle: () async {
                      try {
                        await _favService.removeFavoriteProject(p.id, _token);
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
