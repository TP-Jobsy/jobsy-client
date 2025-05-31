import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../component/custom_nav_bar.dart';
import '../../../model/skill/skill.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';
import '../../../viewmodels/auth_provider.dart';

class SkillSearchScreen extends StatefulWidget {
  const SkillSearchScreen({super.key});

  @override
  State<SkillSearchScreen> createState() => _SkillSearchScreenState();
}

class _SkillSearchScreenState extends State<SkillSearchScreen> {
  late ProjectService _projectService;
  final _controller = TextEditingController();
  final List<Skill> _results = [];
  Timer? _debounce;
  bool _isLoading = false;
  String? _error;
  late AuthProvider _auth;
  bool _hasFetchedPopular = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = context.read<AuthProvider>();
    _projectService = context.read<ProjectService>();

    if (!_hasFetchedPopular) {
      _hasFetchedPopular = true;
      _fetchPopularSkills();
      _auth.addListener(_onAuthReady);
    }
  }

  void _onAuthReady() {
    if (!_hasFetchedPopular && _auth.token != null) {
      _hasFetchedPopular = true;
      _fetchPopularSkills();
      _auth.removeListener(_onAuthReady);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller
      ..removeListener(_onSearchChanged)
      ..dispose();
    if (!_hasFetchedPopular) _auth.removeListener(_onAuthReady);
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.trim();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.length >= 2) {
        _fetchSuggestions(query);
      } else if (query.isEmpty) {
        setState(() => _error = null);
      } else {
        setState(() {
          _results.clear();
          _error = 'Введите минимум 2 символа';
        });
      }
    });
  }

  Future<void> _fetchPopularSkills() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final popular = await _projectService.fetchPopularSkills();
      setState(() {
        _results
          ..clear()
          ..addAll(popular);
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки популярных навыков: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final suggestions = await _projectService.autocompleteSkills(query);
      setState(() {
        _results
          ..clear()
          ..addAll(suggestions);
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка автодополнения: $e';
      });
    } finally {
      setState(() => _isLoading = false);
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
      backgroundColor: Palette.white,
      body: Column(
        children: [
          CustomNavBar(
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/icons/Close.svg',
                  width: isSmallScreen ? 16 : 20,
                  height: isSmallScreen ? 16 : 20,
                  color: Palette.black,
                ),
              ),
            ),
            title: 'Поиск навыков',
            titleStyle: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              fontWeight: FontWeight.w500,
              color: Palette.black,
              fontFamily: 'Inter',
            ),
            trailing: const SizedBox(width: 24),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 20 : 32,
              vertical: isVerySmallScreen ? 8 : 16,
            ),
            child: Container(
              height: isSmallScreen ? 45 : 50,
              decoration: BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Palette.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                maxLength: 20,
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                decoration: InputDecoration(
                  hintText: 'Поиск',
                  hintStyle: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Palette.grey1,
                  ),
                  counterText: '',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icons/Search.svg',
                      width: isSmallScreen ? 13 : 15,
                      height: isSmallScreen ? 13 : 15,
                      color: Palette.grey1,
                    ),
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/Close.svg',
                      width: isSmallScreen ? 15 : 17,
                      height: isSmallScreen ? 15 : 17,
                      color: Palette.navbar,
                    ),
                    onPressed: () {
                      _controller.clear();
                      _fetchPopularSkills();
                    },
                  )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          if (_isLoading)
            const LinearProgressIndicator(color: Palette.primary),
          if (_error != null)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : 32,
                  vertical: isVerySmallScreen ? 4 : 8),
              child: Text(
                _error!,
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Palette.red,
                ),
              ),
            ),

          Expanded(
            child: ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (_, __) => Divider(
                height: 0.5,
                thickness: 0.5,
                color: Palette.grey3,
                indent: 20,
                endIndent: 20,
              ),
              itemBuilder: (ctx, i) {
                final skill = _results[i];
                return ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(
                    skill.name,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  onTap: () => Navigator.pop(ctx, skill),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}