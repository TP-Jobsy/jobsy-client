import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Добавлено для SVG
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
          title: 'Избранные фрилансеры',
          titleStyle: TextStyle(
            fontSize: fontSizeTitle,
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
          ? Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Palette.red,
            ),
          ),
        ),
      )
          : _freelancers.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/OBJECTS.svg',
              width: screenWidth * 0.8,
              height: screenWidth * 0.8,
            ),
            const SizedBox(height: 20),
            Text(
              'Нет избранных фрилансеров',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
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
        itemCount: _freelancers.length,
        itemBuilder: (ctx, i) {
          final f = _freelancers[i];
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxCardWidth,
              ),
              child: FavoritesCardFreelancerModel(
                freelancer: f,
                isFavorite: true,
                onFavoriteToggle: () =>
                    _toggleFavorite(f.id, i),
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