import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../component/custom_bottom_nav_bar.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';

class ProjectSearchScreen extends StatefulWidget {
  const ProjectSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProjectSearchScreen> createState() => _ProjectSearchScreenState();
}

class _ProjectSearchScreenState extends State<ProjectSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _controller = TextEditingController();
  String? _searchQuery;
  int _bottomNavIndex = 1;

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _openSearch() {
    _performSearch();
    _focusNode.unfocus();
  }

  void _handleNavigationTap(int index, BuildContext context) async {
    if (index == _bottomNavIndex) return;

    if (index == 0) {
      setState(() => _bottomNavIndex = 0);
      await Navigator.pushNamed(context, Routes.projects);
    } else if (index == 1) {
      setState(() => _bottomNavIndex = 1);
      await Navigator.pushNamed(context, Routes.searchProject);
    } else if (index == 3) {
      await Navigator.pushNamed(context, Routes.profileFree);
      setState(() => _bottomNavIndex = 3);
    }else if (index == 2) {
      await Navigator.pushNamed(context, Routes.favorites);
      setState(() => _bottomNavIndex = 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: _buildFavoritesContent(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => _handleNavigationTap(i, context),
      ),
    );
  }

  Widget _buildFavoritesContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _openSearch,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 55,
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Palette.dotInactive),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'assets/icons/Search.svg',
                        width: 16,
                        height: 16,
                        color: Palette.black,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Поиск',
                          hintStyle: TextStyle(color: Palette.grey3),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _openSearch,
                      icon: SvgPicture.asset(
                        'assets/icons/Filter.svg',
                        height: 16,
                        color: Palette.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_searchQuery != null && _searchQuery!.isNotEmpty)
              Text(
                'Результаты поиска для: "$_searchQuery"',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
