import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/skill.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';

class SkillSearchScreen extends StatefulWidget {
  const SkillSearchScreen({Key? key}) : super(key: key);

  @override
  State<SkillSearchScreen> createState() => _SkillSearchScreenState();
}

class _SkillSearchScreenState extends State<SkillSearchScreen> {
  final _projectService = ProjectService();
  final _controller = TextEditingController();
  final List<SkillDto> _results = [];
  Timer? _debounce;
  bool _isLoading = false;
  String? _error;
  bool _hasFetchedPopular = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    final auth = context.read<AuthProvider>();
    if (auth.token != null) {
      _hasFetchedPopular = true;
      _fetchPopularSkills();
    } else {
      auth.addListener(_onAuthReady);
    }
  }

  void _onAuthReady() {
    final auth = context.read<AuthProvider>();
    if (!_hasFetchedPopular && auth.token != null) {
      _hasFetchedPopular = true;
      _fetchPopularSkills();
      auth.removeListener(_onAuthReady);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller
      ..removeListener(_onSearchChanged)
      ..dispose();
    context.read<AuthProvider>().removeListener(_onAuthReady);
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.trim();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        _fetchPopularSkills();
      } else if (query.length >= 2) {
        _fetchSuggestions(query);
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
    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() {
        _isLoading = false;
        _error = 'Ошибка: не найден токен';
      });
      return;
    }
    try {
      final popular = await _projectService.fetchPopularSkills(token);
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

  Future<void> _fetchSuggestions(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() {
        _isLoading = false;
        _error = 'Ошибка: не найден токен';
      });
      return;
    }
    try {
      final suggestions = await _projectService.autocompleteSkills(query, token);
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('Поиск навыков'),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
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
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _fetchPopularSkills();
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
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