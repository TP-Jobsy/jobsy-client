import 'package:flutter/material.dart';
import 'package:jobsy/pages/project/selection/category-selections-screen.dart';
import 'package:jobsy/pages/project/selection/specialization_selection_screen.dart';
import 'package:provider/provider.dart';

import '../../../model/category.dart';
import '../../../model/specialization.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';

class ActivityFieldScreenFree extends StatefulWidget {
  const ActivityFieldScreenFree({super.key});

  @override
  State<ActivityFieldScreenFree> createState() =>
      _ActivityFieldScreenFreeState();
}

class _ActivityFieldScreenFreeState extends State<ActivityFieldScreenFree> {
  final _projectService = ProjectService();
  final _formKey = GlobalKey<FormState>();
  String title = '';
  CategoryDto? selectedCategory;
  SpecializationDto? selectedSpecialization;
  List<CategoryDto> categories = [];
  List<SpecializationDto> specializations = [];
  bool isLoading = true;

  void _saveChanges() {
    // Логика сохранения данных
    Navigator.pop(context); // Закрытие экрана после сохранения изменений
  }

  void _cancel() {
    Navigator.pop(context); // Отмена и возвращение на предыдущий экран
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) return;

    try {
      final fetched = await _projectService.fetchCategories(token);
      setState(() {
        categories = fetched;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ошибка загрузки категорий: $e")));
    }
  }

  Future<void> _loadSpecializations(int categoryId) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) return;

    try {
      final specs = await _projectService.fetchSpecializations(
        categoryId,
        token,
      );
      setState(() {
        specializations = specs;
        selectedSpecialization = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка загрузки специализаций: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('О себе'),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
      ),
      backgroundColor: Palette.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        final CategoryDto? cat = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => CategorySelectionScreen(
                                  categories: categories,
                                  selected: selectedCategory,
                                ),
                          ),
                        );
                        if (cat != null) {
                          setState(() {
                            selectedCategory = cat;
                            selectedSpecialization = null;
                            specializations = [];
                          });
                          await _loadSpecializations(cat.id);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Сфера деятельности',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(
                          selectedCategory?.name ?? 'Выберите категорию',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap:
                          selectedCategory == null
                              ? null
                              : () async {
                                final SpecializationDto? spec =
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                SpecializationSelectionScreen(
                                                  items: specializations,
                                                  selected:
                                                      selectedSpecialization,
                                                ),
                                      ),
                                    );
                                if (spec != null) {
                                  setState(() => selectedSpecialization = spec);
                                }
                              },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Специализация',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(
                          selectedSpecialization?.name ??
                              'Выберите специализацию',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              // Кнопки сохранения и отмены, расположенные внизу
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2842F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Сохранить изменения',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _cancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Отмена',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
