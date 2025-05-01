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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Ошибка загрузки категорий: $e")));
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Ошибка загрузки специализаций: $e")));
    }
  }

  Future<void> _pickCategory() async {
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
  }

  Future<void> _pickSpecialization() async {
    final spec = await Navigator.push<SpecializationDto?>(
      context,
      MaterialPageRoute(
        builder: (_) => SpecializationSelectionScreen(
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
        builder: (_) => ExperienceScreen(
          items: ExperienceScreen.statuses,
          selected: selectedExperience,
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    setState(() => _saving = true);
    final dto = FreelancerProfileAboutDto(
      categoryId: selectedCategory!.id,
      specializationId: selectedSpecialization!.id,
      experienceLevel: selectedExperience!,
      aboutMe: '',
      skills: selectedSkills,
    );
    final ok = await context.read<FreelancerProfileProvider>().updateAbout(dto);
    setState(() => _saving = false);

    if (ok) {
      Navigator.pop(context);
    } else {
      final err = context.read<FreelancerProfileProvider>().error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err ?? 'Ошибка сохранения')),
      );
    }
  }

  void _cancel() => Navigator.pop(context);

  Widget _buildChooser({
    required String placeholder,
    required String? value,
    required VoidCallback onTap,
  }) {
    final isSelected = value != null && value.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
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
                  color: isSelected ? Colors.black : Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }

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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildChooser(
                    placeholder: 'Выберите категорию',
                    value: selectedCategory?.name,
                    onTap: _pickCategory,
                  ),
                  _buildChooser(
                    placeholder: 'Выберите специализацию',
                    value: selectedSpecialization?.name,
                    onTap: selectedCategory == null ? (){} : _pickSpecialization,
                  ),
                  _buildChooser(
                    placeholder: 'Выберите опыт работы',
                    value: selectedExperience,
                    onTap: _pickExperience,
                  ),
                  _buildChooser(
                    placeholder: 'Выберите навыки',
                    value: selectedSkills.isEmpty
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
                      backgroundColor: const Color(0xFF2842F7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: _saving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Сохранить изменения',
                        style: TextStyle(color: Colors.white)),
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
                    child: const Text('Отмена', style: TextStyle(color: Colors.black)),
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