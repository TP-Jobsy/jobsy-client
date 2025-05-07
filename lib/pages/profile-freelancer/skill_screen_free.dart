import 'dart:async';
import 'package:flutter/material.dart';
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
  final _projectService = ProjectService();
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

    final token = Provider.of<AuthProvider>(context, listen: false).token;
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
        _error = 'Ошибка: $e';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        // убираем автоматически стрелку назад
        title: const Text('Укажите ваши навыки'),
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
          // Поисковое поле
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Введите название навыка',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                _controller.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _results.clear();
                      _error = null;
                    });
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

          // Ошибка
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(_error!, style: const TextStyle(color: Palette.red, fontFamily: 'Inter')),
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
