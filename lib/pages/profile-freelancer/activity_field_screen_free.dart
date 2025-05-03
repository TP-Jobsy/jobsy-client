import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/category.dart';
import '../../../model/specialization.dart';
import '../../../model/skill.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';
import 'package:jobsy/provider/freelancer_profile_provider.dart';
import 'package:jobsy/model/freelancer_profile_about_dto.dart';
import '../project/selection/category-selections-screen.dart';
import '../project/selection/specialization_selection_screen.dart';
import '../project/selection/experience_screen.dart';
import 'package:jobsy/pages/profile-freelancer/skill_screen_free.dart';

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
  final List<SkillDto> selectedSkills = [];
  String aboutMe = '';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ошибка загрузки категорий: $e")));
    }
  }

  Future<void> _loadSpecializations(int categoryId) async {
    final token = context.read<AuthProvider>().token;
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

  Future<void> _pickCategory() async {
    final cat = await Navigator.push<CategoryDto?>(
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
  }

  Future<void> _pickSpecialization() async {
    final spec = await Navigator.push<SpecializationDto?>(
      context,
      MaterialPageRoute(
        builder:
            (_) => SpecializationSelectionScreen(
              items: specializations,
              selected: selectedSpecialization,
            ),
      ),
    );
    if (spec != null) {
      setState(() => selectedSpecialization = spec);
    }
  }

  Future<void> _pickExperience() async {
    final exp = await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (_) => ExperienceScreen(selected: selectedExperience),
      ),
    );
    if (exp != null) {
      setState(() => selectedExperience = exp);
    }
  }

  Future<void> _pickSkills() async {
    final skill = await Navigator.push<SkillDto>(
      context,
      MaterialPageRoute(builder: (_) => const SkillScreenFree()),
    );
    if (skill != null && !selectedSkills.contains(skill)) {
      setState(() => selectedSkills.add(skill));
    }
  }

  Future<void> _saveChanges() async {
    if (selectedCategory == null ||
        selectedSpecialization == null ||
        selectedExperience == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Заполните все поля')));
      return;
    }

    setState(() => _saving = true);
    final dto = FreelancerProfileAboutDto(
      categoryId: selectedCategory!.id,
      specializationId: selectedSpecialization!.id,
      experienceLevel: selectedExperience!,
      aboutMe: aboutMe,
      skills: selectedSkills,
    );
    final ok = await context.read<FreelancerProfileProvider>().updateAbout(dto);
    setState(() => _saving = false);

    if (ok) {
      Navigator.pop(context);
    } else {
      final err = context.read<FreelancerProfileProvider>().error;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(err ?? 'Ошибка сохранения')));
    }
  }

  void _cancel() => Navigator.pop(context);

  Widget _buildChooser({
    required String label,
    required String placeholder,
    required String? value,
    required VoidCallback onTap,
  }) {
    final isSelected = value != null && value.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Palette.black,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 30),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Palette.grey3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isSelected ? value! : placeholder,
                    style: TextStyle(
                      color: isSelected ? Palette.black : Palette.grey3,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Palette.black),
              ],
            ),
          ),
        ),
      ],
    );
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildChooser(
                    label: 'Категория',
                    placeholder: 'Выберите категорию',
                    value: selectedCategory?.name,
                    onTap: _pickCategory,
                  ),
                  _buildChooser(
                    label: 'Специализация',
                    placeholder: 'Выберите специализацию',
                    value: selectedSpecialization?.name,
                    onTap:
                        selectedCategory == null ? () {} : _pickSpecialization,
                  ),
                  _buildChooser(
                    label: 'Опыт работы',
                    placeholder: 'Выберите опыт работы',
                    value:
                        selectedExperience == null
                            ? null
                            : ExperienceScreen.labelFor(selectedExperience!),
                    onTap: _pickExperience,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'О себе',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Palette.black,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: aboutMe,
                          minLines: 2,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Расскажите о себе',
                            hintStyle: TextStyle(color: Palette.grey3, fontFamily: 'Inter'),
                            alignLabelWithHint: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Palette.grey3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Palette.grey3),
                            ),
                          ),
                          onChanged: (val) => setState(() => aboutMe = val),
                        ),
                      ],
                    ),
                  ),
                  _buildChooser(
                    label: 'Навыки',
                    placeholder: 'Выберите навыки',
                    value:
                        selectedSkills.isEmpty
                            ? null
                            : selectedSkills.map((s) => s.name).join(', '),
                    onTap: _pickSkills,
                  ),
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
                      backgroundColor: Palette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child:
                        _saving
                            ? const CircularProgressIndicator(
                              color: Palette.white,
                            )
                            : const Text(
                              'Сохранить изменения',
                              style: TextStyle(
                                color: Palette.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                              ),
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
                      backgroundColor: Palette.grey20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Отмена',
                      style: TextStyle(color: Palette.black, fontSize: 16, fontFamily: 'Inter'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
