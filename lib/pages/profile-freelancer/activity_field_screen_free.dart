import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:jobsy/component/error_snackbar.dart';
import 'package:jobsy/model/category/category.dart';
import 'package:jobsy/model/specialization/specialization.dart';
import 'package:jobsy/model/skill/skill.dart';
import 'package:jobsy/provider/auth_provider.dart';
import 'package:jobsy/provider/freelancer_profile_provider.dart';
import 'package:jobsy/service/project_service.dart';
import 'package:jobsy/util/palette.dart';
import 'package:jobsy/model/profile/free/freelancer_profile_about_dto.dart';
import 'package:jobsy/pages/project/selection/category-selections-screen.dart';
import 'package:jobsy/pages/project/selection/specialization_selection_screen.dart';
import 'package:jobsy/pages/project/selection/experience_screen.dart';
import 'package:jobsy/pages/profile-freelancer/skill_screen_free.dart';

import '../../model/profile/free/freelancer_profile_dto.dart';

class ActivityFieldScreenFree extends StatefulWidget {
  const ActivityFieldScreenFree({Key? key}) : super(key: key);

  @override
  State<ActivityFieldScreenFree> createState() =>
      _ActivityFieldScreenFreeState();
}

class _ActivityFieldScreenFreeState extends State<ActivityFieldScreenFree> {
  late final ProjectService _projectService;
  final _formKey = GlobalKey<FormState>();
  late List<Skill> selectedSkills;
  late final List<int> _initialSkillIds;
  Category? selectedCategory;
  Specialization? selectedSpecialization;
  String? selectedExperience;
  String aboutMe = '';
  List<Category> categories = [];
  List<Specialization> specializations = [];
  bool isLoading = true;
  bool _saving = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final prof = context.read<FreelancerProfileProvider>().profile!;
    selectedSkills = List<Skill>.from(prof.skills);
    _initialSkillIds = prof.skills.map((s) => s.id).toList();
    aboutMe = prof.about.aboutMe;
    selectedExperience =
    prof.about.experienceLevel.isNotEmpty ? prof.about.experienceLevel : null;
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
    _loadData(prof);
    _initialized = true;
  }

  Future<void> _loadData(FreelancerProfile prof) async {
    try {
      categories = await _projectService.fetchCategories();
      selectedCategory = categories.firstWhereOrNull(
            (c) => c.id == prof.about.categoryId,
      );
      if (selectedCategory != null) {
        specializations = await _projectService.fetchSpecializations(
          selectedCategory!.id,
        );
        selectedSpecialization = specializations.firstWhereOrNull(
              (s) => s.id == prof.about.specializationId,
        );
      }
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: e.toString(),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
    if (cat != null && cat.id != selectedCategory?.id) {
      setState(() {
        selectedCategory = cat;
        selectedSpecialization = null;
        specializations = [];
      });
      try {
        final specs = await _projectService.fetchSpecializations(cat.id);
        setState(() {
          specializations = specs;
        });
      } catch (e) {
        ErrorSnackbar.show(
          context,
          type: ErrorType.error,
          title: 'Ошибка',
          message: e.toString(),
        );
      }
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
    if (selectedSkills.length >= 5) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.warning,
        title: 'Внимание',
        message: 'Нельзя добавить больше 5 навыков',
      );
      return;
    }
    final skill = await Navigator.push<Skill>(
      context,
      MaterialPageRoute(builder: (_) => const SkillScreenFree()),
    );
    if (skill != null && !selectedSkills.any((s) => s.id == skill.id)) {
      setState(() => selectedSkills.add(skill));
    }
  }

  Future<void> _saveChanges() async {
    if (selectedCategory == null ||
        selectedSpecialization == null ||
        selectedExperience == null) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.warning,
        title: 'Ошибка',
        message: 'Пожалуйста, заполните все поля',
      );
      return;
    }
    setState(() => _saving = true);
    final provider = context.read<FreelancerProfileProvider>();
    final aboutDto = FreelancerProfileAbout(
      categoryId: selectedCategory!.id,
      categoryName: selectedCategory!.name,
      specializationId: selectedSpecialization!.id,
      specializationName: selectedSpecialization!.name,
      experienceLevel: selectedExperience!,
      aboutMe: aboutMe,
      skills: [],
    );
    final okAbout = await provider.updateAbout(aboutDto);
    if (!okAbout) {
      setState(() => _saving = false);
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: 'Ошибка сохранения',
      );
      return;
    }
    final currentIds = selectedSkills.map((s) => s.id).toSet();
    final initialIds = _initialSkillIds.toSet();
    final toRemove = initialIds.difference(currentIds);
    final toAdd = currentIds.difference(initialIds);
    for (final id in toRemove) {
      await provider.removeSkill(id);
    }
    for (final id in toAdd) {
      await provider.addSkill(id);
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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
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
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Palette.grey3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: child ??
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isSelected ? value! : placeholder!,
                        style: TextStyle(
                          color: isSelected ? Palette.black : Palette.grey3,
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: 'Inter',
                        ),
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen = screenHeight < 700;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomNavBar(
        title: 'О себе',
        titleStyle: TextStyle(
          fontSize: screenWidth < 360 ? 20 : 22,
          fontFamily: 'Inter',
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: _cancel,
        ),
      ),
      backgroundColor: Palette.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 360 ? 16 : 24,
                      vertical: 16,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                const Text(
                                  'О себе',
                                  style: TextStyle(
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
                                    hintStyle: const TextStyle(
                                      color: Palette.grey3,
                                      fontFamily: 'Inter',
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 12,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Palette.grey3,
                                        width: 1.5,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                      const BorderSide(color: Palette.grey3),
                                    ),
                                  ),
                                  onChanged: (val) =>
                                      setState(() => aboutMe = val),
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
                                    children: selectedSkills
                                        .map(
                                          (skill) => InputChip(
                                        label: Text(
                                          skill.name,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            color: Palette.black,
                                          ),
                                        ),
                                        onDeleted: () => setState(
                                                () => selectedSkills
                                                .remove(skill)),
                                        backgroundColor: Palette.white,
                                        side: const BorderSide(
                                            color: Palette.grey3),
                                        deleteIcon: SvgPicture.asset(
                                          'assets/icons/Close.svg',
                                          width: 15,
                                          height: 15,
                                          color: Palette.black,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              20),
                                        ),
                                      ),
                                    )
                                        .toList(),
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
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              screenWidth < 360 ? 16 : 24, 0, screenWidth < 360 ? 16 : 24, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  child: _saving
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
                child: OutlinedButton(
                  onPressed: _saving ? null : _cancel,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Palette.grey3),
                    backgroundColor: Palette.grey20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Отмена',
                    style: TextStyle(
                      color: Palette.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}