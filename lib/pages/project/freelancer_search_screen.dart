import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../component/custom_bottom_nav_bar.dart';
import '../../component/freelancer_card.dart';
import '../../model/freelancer.dart';
import '../../service/freelancer.service.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';

class FreelancerSearchScreen extends StatefulWidget {
  const FreelancerSearchScreen({Key? key}) : super(key: key);

  @override
  State<FreelancerSearchScreen> createState() => _FreelancerSearchScreenState();
}

class _FreelancerSearchScreenState extends State<FreelancerSearchScreen> {
  int _bottomNavIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _error;

  List<Freelancer> _allFreelancers = [];
  List<Freelancer> _filtered = [];

  String? _selectedPosition; // фильтр по должности

  @override
  void initState() {
    super.initState();
    _loadFreelancers();
  }

  Future<void> _loadFreelancers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final list = await FreelancerService().getAllFreelancers();
      setState(() {
        _allFreelancers = list;
        _applySearchAndFilter();
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

  void _applySearchAndFilter() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filtered = _allFreelancers.where((f) {
        final matchesQuery = query.isEmpty ||
            f.name.toLowerCase().contains(query) ||
            f.position.toLowerCase().contains(query);
        final matchesFilter = _selectedPosition == null ||
            f.position == _selectedPosition;
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  void _onSearchSubmitted(String _) {
    _applySearchAndFilter();
  }

  void _applyFilter() async {
    // получаем список уникальных позиций из данных
    final positions = _allFreelancers
        .map((f) => f.position)
        .toSet()
        .toList()
      ..sort();
    final choice = await showDialog<String?>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Фильтр по должности'),
        children: [
          SimpleDialogOption(
            child: const Text('Все'),
            onPressed: () => Navigator.pop(context, null),
          ),
          ...positions.map((pos) => SimpleDialogOption(
            child: Text(pos),
            onPressed: () => Navigator.pop(context, pos),
          )),
        ],
      ),
    );
    // если пользователь отменил выбор, ничего не меняем
    if (choice != null || _selectedPosition != null) {
      setState(() => _selectedPosition = choice);
      _applySearchAndFilter();
    }
  }

  void _handleNavigationTap(int index, BuildContext context) async {
    if (index == _bottomNavIndex) return;
    if (index == 0) {
      setState(() => _bottomNavIndex = 0);
      await Navigator.pushNamed(context, Routes.projects);
    } else if (index == 1) {
      setState(() => _bottomNavIndex = 1);
      // остаёмся здесь
    } else if (index == 2) {
      setState(() => _bottomNavIndex = 2);
      await Navigator.pushNamed(context, Routes.favorites);
    } else if (index == 3) {
      setState(() => _bottomNavIndex = 3);
      await Navigator.pushNamed(context, Routes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Поиск фрилансеров'),
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => _handleNavigationTap(i, context),
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
                        hintText: 'Поиск фрилансера',
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
                  color: _selectedPosition == null
                      ? Palette.black
                      : Palette.primary,
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
      return Center(child: Text(_error!));
    }
    if (_filtered.isEmpty) {
      return const Center(child: Text('Ничего не найдено'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filtered.length,
      itemBuilder: (ctx, i) {
        final f = _filtered[i];
        return FreelancerCard(
          name: f.name,
          position: f.position,
          location: f.location,
          rating: f.rating,
          avatarUrl: f.avatarUrl,
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.freelancerProfileScreen,
              arguments: f,
            );
          },
        );
      },
    );
  }
}
