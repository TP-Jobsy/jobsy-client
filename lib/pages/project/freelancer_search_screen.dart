import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/pages/project/project_freelancer_search/filter_screen.dart';
import 'package:provider/provider.dart';

import '../../component/custom_bottom_nav_bar.dart';
import '../../component/custom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../component/favorites_card_freelancer.dart';
import '../../model/profile/free/freelancer_list_item.dart';
import '../../model/project/page_response.dart';
import '../../model/skill/skill.dart';
import '../../provider/auth_provider.dart';
import '../../service/favorite_service.dart';
import '../../service/search_service.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';

class FreelancerSearchScreen extends StatefulWidget {
  const FreelancerSearchScreen({Key? key}) : super(key: key);

  @override
  State<FreelancerSearchScreen> createState() => _FreelancerSearchScreenState();
}

class _FreelancerSearchScreenState extends State<FreelancerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SearchService _searchService = SearchService();
  late final FavoriteService _favService;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  List<FreelancerListItem> _freelancers = [];
  Set<int> _favoriteIds = {};

  List<Skill> _filterSkills = [];
  List<int>? _filterSkillIds;

  int _currentPage = 0;
  int _totalPages = 1;
  static const int _pageSize = 20;

  int _bottomNavIndex = 1;

  @override
  void initState() {
    super.initState();
    _favService = FavoriteService();
    _scrollController.addListener(_onScroll);
    _loadPage(0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels + 100 >=
        _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _currentPage < _totalPages - 1) {
      _loadPage(_currentPage + 1, append: true);
    }
  }

  Future<void> _loadPage(int page, {bool append = false}) async {
    if (append) {
      setState(() => _isLoadingMore = true);
    } else {
      setState(() {
        _isLoading = true;
        _error = null;
        _currentPage = 0;
        _totalPages = 1;
      });
    }

    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() {
        _error = 'Не авторизованы';
        _isLoading = false;
        _isLoadingMore = false;
      });
      return;
    }

    try {
      final term = _searchController.text.trim();
      final PageResponse<FreelancerListItem> resp =
      await _searchService.searchFreelancers(
        token: token,
        skillIds: _filterSkillIds,
        term: term.isEmpty ? null : term,
        page: page,
        size: _pageSize,
      );

      final favList = await _favService.fetchFavoriteFreelancers(token);

      setState(() {
        _favoriteIds = favList.map((f) => f.id!).toSet();
        _currentPage = resp.number;
        _totalPages = resp.totalPages;
        if (append) {
          _freelancers.addAll(resp.content);
        } else {
          _freelancers = resp.content;
        }
      });
    } catch (e) {
      setState(() => _error = 'Ошибка загрузки: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _applyFilter() async {
    final result = await Navigator.push<List<Skill>>(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(initialSelected: _filterSkills),
      ),
    );
    if (result != null) {
      _filterSkills = result;
      _filterSkillIds = result.map((s) => s.id).toList();
      _loadPage(0);
    }
  }

  Future<void> _toggleFavorite(int freelancerId) async {
    final token = context.read<AuthProvider>().token!;
    final isFav = _favoriteIds.contains(freelancerId);
    try {
      if (isFav) {
        await _favService.removeFavoriteFreelancer(freelancerId, token);
        _favoriteIds.remove(freelancerId);
      } else {
        await _favService.addFavoriteFreelancer(freelancerId, token);
        _favoriteIds.add(freelancerId);
      }
      setState(() {});
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Не удалось обновить избранное',
        message:' $e',
      );
    }
  }

  void _onNavTap(int idx) {
    if (idx == _bottomNavIndex) return;
    setState(() => _bottomNavIndex = idx);
    switch (idx) {
      case 0:
        Navigator.pushReplacementNamed(context, Routes.projects);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, Routes.favoritesFreelancers);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, Routes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(leading: const SizedBox(), title: '', trailing: const SizedBox()),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
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
                boxShadow: [BoxShadow(color: Palette.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SvgPicture.asset('assets/icons/Search.svg', width: 16, height: 16, color: Palette.black),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _loadPage(0),
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
                  color:
                  _filterSkillIds == null ? Palette.black : Palette.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));
    if (_freelancers.isEmpty) return const Center(child: Text('Ничего не найдено'));

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _freelancers.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == _freelancers.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final f = _freelancers[i];
        final isFav = _favoriteIds.contains(f.id);
        return FavoritesCardFreelancer(
          freelancerItem: f,
          isFavorite: isFav,
          onFavoriteToggle: () => _toggleFavorite(f.id!),
          onTap: () => Navigator.pushNamed(
            context,
            Routes.freelancerProfileScreen,
            arguments: f.id,
          ),
        );
      },
    );
  }
}