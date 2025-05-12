import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../component/custom_bottom_nav_bar.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../component/favorites_card_freelancer.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/favorite_service.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';

class FavoritesFreelancersScreen extends StatefulWidget {
  const FavoritesFreelancersScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesFreelancersScreen> createState() => _FavoritesFreelancersScreenState();
}

class _FavoritesFreelancersScreenState extends State<FavoritesFreelancersScreen> {
  final List<dynamic> _freelancers = [];
  bool _isLoading = true;
  String? _error;
  int _bottomNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() {
        _error = 'Токен не найден';
        _isLoading = false;
      });
      return;
    }

    try {
      final list = await context.read<FavoriteService>().fetchFavoriteFreelancers(token);
      setState(() {
        _freelancers.clear();
        _freelancers.addAll(list);
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

  Future<void> _toggleFavorite(int freelancerId) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    try {
      await context.read<FavoriteService>().removeFavoriteFreelancer(freelancerId, token);
      setState(() {
        _freelancers.removeWhere((f) => f.id == freelancerId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось удалить из избранного: $e')),
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
      body: _isLoading
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
          return FavoritesCardFreelancer(
            freelancer: f,
            isFavorite: true,
            onFavoriteToggle: () => _toggleFavorite(f.id),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.freelancerProfileScreen,
                arguments: f,
              );
            },
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