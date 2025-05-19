import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../../model/category/category.dart';
import '../../model/specialization/specialization.dart';
import '../../model/skill/skill.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';
import 'package:jobsy/provider/freelancer_profile_provider.dart';
import 'package:jobsy/model/profile/free/freelancer_profile_about_dto.dart';
import '../project/selection/category-selections-screen.dart';
import '../project/selection/specialization_selection_screen.dart';
import '../project/selection/experience_screen.dart';
import 'package:jobsy/pages/profile-freelancer/skill_screen_free.dart';

class ActivityFieldScreenFree extends StatefulWidget {
  const ActivityFieldScreenFree({super.key});

  @override
  State<ActivityFieldScreenFree> createState() => _ActivityFieldScreenFreeState();
}

class _ActivityFieldScreenFreeState extends State<ActivityFieldScreenFree> {
  final _projectService = ProjectService();
  final _formKey = GlobalKey<FormState>();
  List<Skill> selectedSkills = [];
  Category? selectedCategory;
  Specialization? selectedSpecialization;
  String? selectedExperience;
  String aboutMe = '';

  List<Category> categories = [];
  List<Specialization> specializations = [];
  bool isLoading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _loadCategories().then((_) {
      final about = context.read<FreelancerProfileProvider>().profile?.about;
      selectedCategory = categories.firstWhereOrNull((c) => c.id == about?.categoryId);
      if (selectedCategory != null) {
        _loadSpecializations(selectedCategory!.id).then((_) {
          selectedSpecialization = specializations.firstWhereOrNull((s) => s.id == about?.specializationId);
          setState(() {});
        });
      }

      selectedExperience = about?.experienceLevel.isNotEmpty == true ? about?.experienceLevel : null;
      aboutMe = about?.aboutMe ?? '';

      setState(() {});
    });
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка загрузки категорий: $e")));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка загрузки специализаций: $e")));
    }
  }

  Future<void> _pickCategory() async {
    final cat = await Navigator.push<Category?>(
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
    if (selectedCategory == null) return;
    final spec = await Navigator.push<Specialization?>(
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
        builder: (_) => ExperienceScreen(selected: selectedExperience),
      ),
    );
    if (exp != null) {
      setState(() => selectedExperience = exp);
    }
  }

  Future<void> _pickSkills() async {
    final skill = await Navigator.push<Skill>(
      context,
      MaterialPageRoute(builder: (_) => const SkillScreenFree()),
    );
    if (skill == null) return;
    if (!selectedSkills.any((s) => s.id == skill.id)) {
      setState(() => selectedSkills.add(skill));
    }
  }

  Future<void> _saveChanges() async {
    if (selectedCategory == null ||
        selectedSpecialization == null ||
        selectedExperience == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Заполните все поля')));
      return;
    }

    setState(() => _saving = true);

    final aboutDto = FreelancerProfileAbout(
      categoryId: selectedCategory!.id,
      categoryName: selectedCategory!.name,
      specializationId: selectedSpecialization!.id,
      specializationName: selectedSpecialization!.name,
      experienceLevel: selectedExperience!,
      aboutMe: aboutMe,
      skills: [],
    );

    final provider = context.read<FreelancerProfileProvider>();
    final okAbout = await provider.updateAbout(aboutDto);

    if (!okAbout) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Ошибка сохранения')),
      );
      return;
    }

    for (final skill in selectedSkills) {
      await provider.addSkill(skill.id);
    }

    await provider.loadProfile();

    setState(() => _saving = false);
    Navigator.pop(context);
  }

  void _cancel() => Navigator.pop(context);

  Widget _buildChooser({
    required String label,
    required VoidCallback onTap,
    String? value,
    String? placeholder,
    Widget? child,
  }) {
    final isSelected = value != null && value.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Palette.black, fontFamily: 'Inter'),
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
            child: child ??
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isSelected ? value! : placeholder!,
                        style: TextStyle(
                          color: isSelected ? Palette.black : Palette.grey3,
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    SvgPicture.asset('assets/icons/ArrowRight.svg', width: 12, height: 12, color: Palette.navbar),
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
      appBar: CustomNavBar(
        title: 'О себе',
        titleStyle: TextStyle(fontSize: 22),
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/ArrowLeft.svg', width: 20, height: 20, color: Palette.navbar),
          onPressed: _cancel,
        ),
      ),
      backgroundColor: Palette.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
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
                      onTap: _pickSpecialization,
                    ),
                    _buildChooser(
                      label: 'Опыт работы',
                      placeholder: 'Выберите опыт работы',
                      value: selectedExperience == null
                          ? null
                          : ExperienceScreen.labelFor(selectedExperience!),
                      onTap: _pickExperience,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('О себе', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Palette.black, fontFamily: 'Inter')),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: aboutMe,
                            minLines: 2,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Расскажите о себе',
                              hintStyle: TextStyle(color: Palette.grey3, fontFamily: 'Inter'),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Palette.grey3, width: 1.5),
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
                      onTap: _pickSkills,
                      child: Row(
                        children: [
                          Expanded(
                            child: selectedSkills.isEmpty
                                ? const Text(
                              'Выбрать навыки',
                              style: TextStyle(
                                color: Palette.grey3,
                                fontSize: 16,
                                fontFamily: 'Inter',
                              ),
                            )
                                : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: selectedSkills.map((skill) {
                                return InputChip(
                                  label: Text(
                                    skill.name,
                                    style: const TextStyle(fontFamily: 'Inter', color: Palette.black),
                                  ),
                                  backgroundColor: Palette.white,
                                  side: const BorderSide(color: Palette.grey3),
                                  deleteIcon: SvgPicture.asset(
                                    'assets/icons/Close.svg',
                                    width: 15,
                                    height: 15,
                                    color: Palette.black,
                                  ),
                                  onDeleted: () => setState(() => selectedSkills.remove(skill)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/icons/ArrowRight.svg',
                            width: 12,
                            height: 12,
                            color: Palette.navbar,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: _saving
                        ? const CircularProgressIndicator(color: Palette.white)
                        : const Text('Сохранить изменения', style: TextStyle(color: Palette.white, fontSize: 16, fontFamily: 'Inter')),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Отмена', style: TextStyle(color: Palette.black, fontSize: 16, fontFamily: 'Inter')),
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