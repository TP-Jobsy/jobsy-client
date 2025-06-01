import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../component/custom_bottom_nav_bar.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../component/error_snackbar.dart';
import '../../../component/favorites_card_client.dart';
import '../../../model/project/page_response.dart';
import '../../../model/project/project_list_item.dart';
import '../../../model/skill/skill.dart';
import '../../../service/client_project_service.dart';
import '../../../service/favorite_service.dart';
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
  late final SearchService _searchService;
  late final FavoriteService _favService;
  late final ClientProjectService _projectService;
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
    _searchService = context.read<SearchService>();
    _favService = context.read<FavoriteService>();
    _projectService = context.read<ClientProjectService>();
    AppMetrica.reportEvent('ProjectSearchScreen_opened');
    _loadAllData();
  }

  Future<void> _loadAllData({int page = 0, int size = 20}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final term = _searchController.text.trim();
      _page = await _searchService.searchProjects(
        skillIds: _filterSkillIds,
        term: term.isEmpty ? null : term,
        page: page,
        size: size,
      );
      _projects = _page!.content;
      final favList = await _favService.fetchFavoriteProjects();
      _favoriteIds = favList.map((p) => p.id).toSet();
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _isLoading = false);
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
      AppMetrica.reportEventWithMap(
        'ProjectSearchScreen_filter_applied',
        {'skillIds': _filterSkillIds ?? []},
      );
      _loadAllData();
    }
  }

  void _onSearchSubmitted(String _) {
    final term = _searchController.text.trim();
    AppMetrica.reportEventWithMap(
      'ProjectSearchScreen_search_submitted',
      {'term': term.isEmpty ? '' : term},
    );
    _loadAllData();
  }

  Future<void> _toggleFavorite(int projectId) async {
    final isFav = _favoriteIds.contains(projectId);
    try {
      if (isFav) {
        await _favService.removeFavoriteProject(projectId);
        _favoriteIds.remove(projectId);
      } else {
        await _favService.addFavoriteProject(projectId);
        _favoriteIds.add(projectId);
      }
      setState(() {});
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Не удалось обновить избранное',
        message: '$e',
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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenHeight < 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        leading: const SizedBox(),
        title: '',
        trailing: const SizedBox(),
      ),
      body: Column(
        children: [
          _buildSearchBar(isSmallScreen, isVerySmallScreen),
          Expanded(child: _buildBody(isSmallScreen)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildSearchBar(bool isSmallScreen, bool isVerySmallScreen) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isSmallScreen ? 16 : 30,
        0,
        isSmallScreen ? 16 : 30,
        isVerySmallScreen ? 12 : 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: isSmallScreen ? 48 : 55,
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
                  SizedBox(width: isSmallScreen ? 12 : 16),
                  SvgPicture.asset(
                    'assets/icons/Search.svg',
                    width: isSmallScreen ? 14 : 16,
                    height: isSmallScreen ? 14 : 16,
                    color: Palette.black,
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: _onSearchSubmitted,
                      maxLength: 50,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Поиск',
                        hintStyle: TextStyle(
                          color: Palette.grey3,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          GestureDetector(
            onTap: _applyFilter,
            child: Container(
              width: isSmallScreen ? 48 : 55,
              height: isSmallScreen ? 48 : 55,
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
                  width: isSmallScreen ? 14 : 16,
                  height: isSmallScreen ? 14 : 16,
                  color: Palette.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(bool isSmallScreen) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(
          'Ошибка загрузки: $_error',
          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
        ),
      );
    }
    if (_projects.isEmpty) {
      return const Center(child: Text('Нет доступных проектов'));
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 6 : 8,
      ),
      itemCount: _projects.length,
      itemBuilder: (ctx, i) {
        final item = _projects[i];
        final isFav = _favoriteIds.contains(item.id);

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? 380 : 410,
            ),
            child: FavoritesCardClient(
              project: item,
              isFavorite: isFav,
              onFavoriteToggle: () => _toggleFavorite(item.id),
              onTap: () {
                AppMetrica.reportEventWithMap(
                  'ProjectSearchScreen_tap_projectItem',
                  {'projectId': item.id},
                );
                Navigator.pushNamed(
                  context,
                  Routes.projectDetailFree,
                  arguments: item.id,
                ).then((_) => _loadAllData());
              },
            ),
          ),
        );
      },
    );
  }
}