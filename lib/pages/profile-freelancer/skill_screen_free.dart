import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../model/skill/skill.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';

class SkillScreenFree extends StatefulWidget {
  const SkillScreenFree({super.key});

  @override
  State<SkillScreenFree> createState() => _SkillScreenFreeState();
}

class _SkillScreenFreeState extends State<SkillScreenFree> {
  late final ProjectService _projectService;
  final TextEditingController _controller = TextEditingController();
  final List<Skill> _results = [];
  Timer? _debounce;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.trim();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 3), () {
      if (query.length < 2) {
        setState(() {
          _results.clear();
          _error = query.isEmpty ? null : 'Введите минимум 2 символа';
        });
      } else {
        _fetchSuggestions(query);
      }
    });
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
        _error = 'Ошибка: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    final auth = context.read<AuthProvider>();
    _projectService = ProjectService(
      getToken: () async {
        await auth.ensureLoaded();
        return auth.token;
      },
      refreshToken: () async {
        await auth.refreshTokens();
      },
    );
    _fetchPopularSkills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(
        leading: const SizedBox(width: 35),
        title: 'Укажите ваши навыки',
        titleStyle: TextStyle(fontSize: 22),
        trailing: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/Close.svg',
            width: 20,
            height: 20,
            color: Palette.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Palette.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Введите название навыка',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    'assets/icons/Search.svg',
                    width: 17,
                    height: 17,
                    color: Palette.black,
                  ),
                ),
                suffixIcon:
                    _controller.text.isNotEmpty
                        ? IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/Close.svg',
                            width: 17,
                            height: 17,
                            color: Palette.black,
                          ),
                          onPressed: () {
                            _controller.clear();
                            setState(() {
                              _results.clear();
                              _error = null;
                            });
                          },
                        )
                        : null,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: Palette.grey3,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Palette.grey3),
                ),
              ),
            ),
          ),

          if (_isLoading) const LinearProgressIndicator(),

          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _error!,
                style: const TextStyle(color: Palette.red, fontFamily: 'Inter'),
              ),
            ),

          Expanded(
            child: ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final skill = _results[i];
                return ListTile(
                  title: Text(skill.name),
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
