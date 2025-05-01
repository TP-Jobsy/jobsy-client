import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/category.dart';
import '../../../model/specialization.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';

import 'package:jobsy/provider/freelancer_profile_provider.dart';
import 'package:jobsy/model/freelancer_profile_about_dto.dart';

import '../project/selection/category-selections-screen.dart';
import '../project/selection/specialization_selection_screen.dart';
import '../project/selection/experience_screen.dart';

class ActivityFieldScreenFree extends StatefulWidget {
  const ActivityFieldScreenFree({Key? key}) : super(key: key);

  @override
  State<ActivityFieldScreenFree> createState() =>
      _ActivityFieldScreenFreeState();
}

class _ActivityFieldScreenFreeState extends State<ActivityFieldScreenFree> {
  final _projectService = ProjectService();
  final _formKey = GlobalKey<FormState>();

  CategoryDto? selectedCategory;
  SpecializationDto? selectedSpecialization;
  String? selectedExperience;

  List<CategoryDto> categories = [];
  List<SpecializationDto> specializations = [];

  bool isLoading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    try {
      final fetched = await _projectService.fetchCategories(token);
      setState(() {
        categories = fetched;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка загрузки категорий: $e")),
      );
    }
  }

  Future<void> _loadSpecializations(int categoryId) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    try {
      final specs = await _projectService.fetchSpecializations(categoryId, token);
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

  Future<void> _pickExperience() async {
    final choice = await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (_) => ExperienceScreen(
          items: ExperienceScreen.statuses,
          selected: selectedExperience,
        ),
      ),
    );
    if (choice != null) {
      setState(() => selectedExperience = choice);
    }
  }

  Future<void> _saveChanges() async {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Выберите категорию')));
      return;
    }
    if (selectedSpecialization == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Выберите специализацию')));
      return;
    }
    if (selectedExperience == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Выберите опыт работы')));
      return;
    }

    setState(() => _saving = true);
    final provider = context.read<FreelancerProfileProvider>();
    final dto = FreelancerProfileAboutDto(
      categoryId: selectedCategory!.id,
      specializationId: selectedSpecialization!.id,
      experienceLevel: selectedExperience!,
      aboutMe: '',
      skills: [],
    );
    final ok = await provider.updateAbout(dto);
    setState(() => _saving = false);

    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Ошибка сохранения')),
      );
    }
  }

  void _cancel() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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

                    // Сфера деятельности
                    InkWell(
                      onTap: () async {
                        final cat = await Navigator.push<CategoryDto?>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategorySelectionScreen(
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
                          suffixIcon: Icon(Icons.arrow_forward_ios),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(
                          selectedCategory?.name ?? 'Выберите категорию',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Специализация
                    InkWell(
                      onTap: selectedCategory == null
                          ? null
                          : () async {
                        final spec =
                        await Navigator.push<SpecializationDto?>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SpecializationSelectionScreen(
                                  items: specializations,
                                  selected: selectedSpecialization,
                                ),
                          ),
                        );
                        if (spec != null) {
                          setState(
                                  () => selectedSpecialization = spec);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Специализация',
                          suffixIcon: Icon(Icons.arrow_forward_ios),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(
                          selectedSpecialization?.name ??
                              'Выберите специализацию',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Опыт работы
                    InkWell(
                      onTap: _pickExperience,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Опыт работы',
                          suffixIcon: Icon(Icons.arrow_forward_ios),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(
                          selectedExperience ?? 'Выберите опыт работы',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // Кнопки
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2842F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: _saving
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : const Text(
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
                      onPressed: _saving ? null : _cancel,
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