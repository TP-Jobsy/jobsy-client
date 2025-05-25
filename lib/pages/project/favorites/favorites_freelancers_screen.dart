import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../component/custom_bottom_nav_bar.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../component/error_snackbar.dart';
import '../../../component/favorited_card_freelancer_model.dart';
import '../../../service/favorite_service.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';

class FavoritesFreelancersScreen extends StatefulWidget {
  const FavoritesFreelancersScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesFreelancersScreen> createState() =>
      _FavoritesFreelancersScreenState();
}

class _FavoritesFreelancersScreenState
    extends State<FavoritesFreelancersScreen> {
  late final FavoriteService _favService;
  List<dynamic> _freelancers = [];
  bool _isLoading = true;
  String? _error;
  int _bottomNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _favService = context.read<FavoriteService>();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final list = await _favService.fetchFavoriteFreelancers();
      setState(() {
        _freelancers = list;
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(int freelancerId, int index) async {
    try {
      await _favService.removeFavoriteFreelancer(freelancerId);
      setState(() {
        _freelancers.removeAt(index);
      });
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Не удалось удалить из избранного',
        message: '$e',
      );
    }
  }

  void _onNavTap(int index) {
    if (index == _bottomNavIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, Routes.projects);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, Routes.freelancerSearch);
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, Routes.profile);
        break;
    }
    setState(() => _bottomNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomNavBar(
          leading: const SizedBox(),
          title: 'Избранные фрилансеры',
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
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : _freelancers.isEmpty
              ? const Center(child: Text('Нет избранных фрилансеров'))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _freelancers.length,
                itemBuilder: (ctx, i) {
                  final f = _freelancers[i];
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: FavoritesCardFreelancerModel(
                        freelancer: f,
                        isFavorite: true,
                        onFavoriteToggle: () => _toggleFavorite(f.id, i),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.freelancerProfileScreen,
                            arguments: f.id,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
