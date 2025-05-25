import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:jobsy/pages/project/selection/category-selections-screen.dart';
import 'package:jobsy/pages/project/selection/specialization_selection_screen.dart';
import '../../../component/error_snackbar.dart';
import '../../../model/category/category.dart';
import '../../../model/specialization/specialization.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/project_service.dart';
import '../../../component/progress_step_indicator.dart';
import '../../../util/palette.dart';
import '../new_project/new_project_step2_screen.dart';

class NewProjectStep1Screen extends StatefulWidget {
  const NewProjectStep1Screen({Key? key}) : super(key: key);

  @override
  _NewProjectStep1ScreenState createState() => _NewProjectStep1ScreenState();
}

class _NewProjectStep1ScreenState extends State<NewProjectStep1Screen> {
  late final ProjectService _projectService;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  Category? selectedCategory;
  Specialization? selectedSpecialization;

  List<Category> categories = [];
  List<Specialization> specializations = [];

  bool isLoadingCategories = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _projectService = context.read<ProjectService>();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => isLoadingCategories = true);
    try {
      categories = await _projectService.fetchCategories();
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка загрузки категорий',
        message: e.toString(),
      );
    } finally {
      setState(() => isLoadingCategories = false);
    }
  }

  Future<void> _loadSpecializations(int categoryId) async {
    try {
      specializations = await _projectService.fetchSpecializations(categoryId);
      selectedSpecialization = null;
      setState(() {});
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка загрузки специализаций',
        message: e.toString(),
      );
    }
  }

  Future<void> _pickCategory() async {
    final cat = await Navigator.push<Category?>(
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
    if (selectedCategory == null) return;
    final spec = await Navigator.push<Specialization?>(
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

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null || selectedSpecialization == null) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.warning,
        title: 'Ошибка',
        message: 'Пожалуйста, заполните все поля',
      );
      return;
    }

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) return;

    final data = {
      'title': _titleController.text,
      'category': {'id': selectedCategory!.id},
      'specialization': {'id': selectedSpecialization!.id},
    };

    setState(() => isSubmitting = true);
    try {
      final project = await _projectService.createDraft(data);
      final draftId = project.id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  NewProjectStep2Screen(draftId: draftId, previousData: data),
        ),
      );
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка создания черновика',
        message: ' $e',
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingCategories) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomNavBar(
        title: '',
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Palette.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const ProgressStepIndicator(totalSteps: 6, currentStep: 0),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Основная информация',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                // <- важно
                child: ListView(
                  children: [
                    const Text(
                      'Заголовок',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Palette.black,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Введите заголовок проекта',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.grey3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Palette.grey3,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.red),
                        ),
                      ),
                      validator:
                          (val) =>
                              (val == null || val.trim().isEmpty)
                                  ? 'Введите заголовок'
                                  : null,
                    ),
                    const SizedBox(height: 30),
                    const Text('Категория'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickCategory,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Palette.grey3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedCategory?.name ?? 'Выберите категорию',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Palette.black,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SvgPicture.asset(
                              'assets/icons/ArrowRight.svg',
                              width: 12,
                              height: 12,
                              color: Palette.secondaryIcon,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Специализация'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap:
                          selectedCategory == null ? null : _pickSpecialization,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Palette.grey3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedSpecialization?.name ??
                                    'Выберите специализацию',
                              ),
                            ),
                            const SizedBox(width: 12),
                            SvgPicture.asset(
                              'assets/icons/ArrowRight.svg',
                              width: 12,
                              height: 12,
                              color: Palette.secondaryIcon,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child:
                          isSubmitting
                              ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Palette.white,
                                ),
                              )
                              : const Text(
                                'Продолжить',
                                style: TextStyle(
                                  color: Palette.white,
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
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.grey3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Назад',
                        style: TextStyle(
                          color: Palette.white,
                          fontFamily: 'Inter',
                        ),
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
