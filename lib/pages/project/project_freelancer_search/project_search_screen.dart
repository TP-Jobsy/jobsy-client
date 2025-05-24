import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../component/custom_bottom_nav_bar.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../component/error_snackbar.dart';
import '../../../component/favorites_card_client.dart';
import '../../../model/project/page_response.dart';
import '../../../model/project/project.dart';
import '../../../model/project/project_list_item.dart';
import '../../../model/skill/skill.dart';
import '../../../service/client_project_service.dart';
import '../../../service/favorite_service.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/search_service.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';
import 'filter_screen.dart';

class ProjectSearchScreen extends StatefulWidget {
  const ProjectSearchScreen({super.key});

  @override
  State<ProjectSearchScreen> createState() => _ProjectSearchScreenState();
}

class _ProjectSearchScreenState extends State<ProjectSearchScreen> {
  final _searchService = SearchService();
  late final FavoriteService _favService;
  final _searchController = TextEditingController();
  int _bottomNavIndex = 1;

  List<Skill> _filterSkills = [];
  List<ProjectListItem> _projects = [];
  PageResponse<ProjectListItem>? _page;
  Set<int> _favoriteIds = {};
  List<int>? _filterSkillIds;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _favService = context.read<FavoriteService>();
    _loadAllData();
  }

  Future<void> _loadAllData({int page = 0, int size = 20}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() {
        _isLoading = false;
        _error = 'Токен не найден';
      });
      return;
    }

    try {
      final term = _searchController.text.trim();
      final pageResp = await _searchService.searchProjects(
        token: token,
        skillIds: _filterSkillIds,
        term: term.isEmpty ? null : term,
        page: page,
        size: size,
      );
      final favList = await _favService.fetchFavoriteProjects(token);

      setState(() {
        _page = pageResp;
        _projects = pageResp.content;
        _favoriteIds = favList.map((p) => p.id).toSet();
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _applyFilter() async {
    final selected = await Navigator.push<List<Skill>>(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(initialSelected: _filterSkills),
      ),
    );
    if (selected != null) {
      setState(() {
        _filterSkills = selected;
        _filterSkillIds = selected.map((s) => s.id).toList();
      });
      _loadAllData();
    }
  }

  void _onSearchSubmitted(String _) => _loadAllData();

  Future<void> _toggleFavorite(int projectId) async {
    final token = context.read<AuthProvider>().token!;
    final isFav = _favoriteIds.contains(projectId);
    try {
      if (isFav) {
        await _favService.removeFavoriteProject(projectId, token);
        _favoriteIds.remove(projectId);
      } else {
        await _favService.addFavoriteProject(projectId, token);
        _favoriteIds.add(projectId);
      }
      setState(() {});
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Не удалось обновить избранное',
        message:'$e',
      );
    }
  }

  void _onNavTap(int idx) {
    if (idx == _bottomNavIndex) return;
    setState(() => _bottomNavIndex = idx);
    switch (idx) {
      case 0:
        Navigator.pushReplacementNamed(context, Routes.projectsFree);
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, Routes.favorites);
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
      appBar: CustomNavBar(
        leading: const SizedBox(),
        title: '',
        trailing: const SizedBox(),
      ),
      body: Column(
        children: [_buildSearchBar(), Expanded(child: _buildBody())],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Palette.dotInactive),
                boxShadow: [
                  BoxShadow(
                    color: Palette.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SvgPicture.asset(
                    'assets/icons/Search.svg',
                    width: 16,
                    height: 16,
                    color: Palette.black,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: _onSearchSubmitted,
                      decoration: InputDecoration(
                        hintText: 'Поиск',
                        hintStyle: TextStyle(color: Palette.grey3),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _applyFilter,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Palette.white,
                shape: BoxShape.circle,
                border: Border.all(color: Palette.dotInactive),
                boxShadow: [
                  BoxShadow(
                    color: Palette.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/Filter.svg',
                  width: 16,
                  height: 16,
                  color: Palette.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Ошибка загрузки: $_error'));
    }
    if (_projects.isEmpty) {
      return const Center(child: Text('Нет доступных проектов'));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final item = _projects[i];
        final isFav = _favoriteIds.contains(item.id);
        return FavoritesCardClient(
          project: item,
          isFavorite: isFav,
          onFavoriteToggle: () => _toggleFavorite(item.id),
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.projectDetailFree,
              arguments: item.id,
            ).then((_) => _loadAllData());
          },
        );
      },
    );
  }
}
