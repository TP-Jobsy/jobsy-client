import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../component/custom_bottom_nav_bar.dart';
import '../../../component/error_snackbar.dart';
import '../../../component/favorites_card_client.dart';
import '../../../model/project/project.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/search_service.dart';
import '../../../service/favorite_service.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';

class ProjectSearchScreen extends StatefulWidget {
  const ProjectSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProjectSearchScreen> createState() => _ProjectSearchScreenState();
}

class _ProjectSearchScreenState extends State<ProjectSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Project> _results = [];
  Set<int> _favoriteIds = {};
  bool _isLoading = false;
  String? _error;
  int _bottomNavIndex = 1;

  late final String _token;
  late final SearchService _searchService;
  late final FavoriteService _favService;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _token = auth.token ?? '';
    _searchService = context.read<SearchService>();
    _favService    = context.read<FavoriteService>();

    // Подгружаем уже избранные проекты
    _loadFavorites();

    // Слушаем изменения ввода
    _searchController.addListener(_onQueryChanged);
  }

  void _onQueryChanged() {
    final term = _searchController.text.trim();
    if (term.length >= 2) {
      _performSearch(term);
    } else if (term.isEmpty) {
      setState(() {
        _results.clear();
        _error = null;
      });
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final favs = await _favService.fetchFavoriteProjects(_token);
      setState(() {
        _favoriteIds = favs.map((p) => p.id).toSet();
      });
    } catch (_) {
      // Можно проигнорировать ошибку здесь
    }
  }

  Future<void> _performSearch(String term) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final list = await _searchService.searchProjects(
        token: _token,
        term: term,
      );
      setState(() => _results = list);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite(Project proj) async {
    final isFav = _favoriteIds.contains(proj.id);
    try {
      if (isFav) {
        await _favService.removeFavoriteProject(proj.id, _token);
        setState(() => _favoriteIds.remove(proj.id));
        ErrorSnackbar.show(
          context,
          type: ErrorType.success,
          title: 'Удалено',
          message: 'Проект убран из избранного',
        );
      } else {
        await _favService.addFavoriteProject(proj.id, _token);
        setState(() => _favoriteIds.add(proj.id));
        ErrorSnackbar.show(
          context,
          type: ErrorType.success,
          title: 'Добавлено',
          message: 'Проект добавлен в избранное',
        );
      }
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: e.toString(),
      );
    }
  }

  void _handleNavigationTap(int i) async {
    if (i == _bottomNavIndex) return;
    switch (i) {
      case 0:
        await Navigator.pushNamed(context, Routes.projectsFree);
        break;
      case 2:
        await Navigator.pushNamed(context, Routes.favorites);
        break;
      case 3:
        await Navigator.pushNamed(context, Routes.profileFree);
        break;
    }
    setState(() => _bottomNavIndex = i);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.white,
        centerTitle: false,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Поиск проектов',
            border: InputBorder.none,
            prefixIcon: SvgPicture.asset('assets/icons/Search.svg', color: Palette.grey3),
          ),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: _handleNavigationTap,
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Ошибка: $_error', style: const TextStyle(color: Colors.red)));
    }
    if (_results.isEmpty && _searchController.text.trim().length >= 2) {
      return const Center(child: Text('Ничего не найдено'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      itemBuilder: (_, i) {
        final proj = _results[i];
        return FavoritesCardProject(
          project: proj,
          isFavorite: _favoriteIds.contains(proj.id),
          onFavoriteToggle: () => _toggleFavorite(proj),
        );
      },
    );
  }
}