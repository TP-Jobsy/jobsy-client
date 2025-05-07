import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:jobsy/pages/project/selection/category-selections-screen.dart';
import 'package:jobsy/pages/project/selection/specialization_selection_screen.dart';
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
  final _projectService = ProjectService();
  final _formKey = GlobalKey<FormState>();

  String title = '';
  Category? selectedCategory;
  Specialization? selectedSpecialization;

  List<Category> categories = [];
  List<Specialization> specializations = [];
  bool isLoadingCategories = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      setState(() => isLoadingCategories = false);
      return;
    }
    try {
      final fetched = await _projectService.fetchCategories(token);
      setState(() {
        categories = fetched;
        isLoadingCategories = false;
      });
    } catch (e) {
      setState(() => isLoadingCategories = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки категорий: $e')),
      );
    }
  }

  Future<void> _loadSpecializations(int categoryId) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) return;
    try {
      final specs = await _projectService.fetchSpecializations(categoryId, token);
      setState(() {
        specializations = specs;
        selectedSpecialization = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки специализаций: $e')),
      );
    }
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null || selectedSpecialization == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) return;

    final data = {
      'title': title,
      'category': {'id': selectedCategory!.id},
      'specialization': {'id': selectedSpecialization!.id},
    };

    setState(() => isSubmitting = true);
    try {
      final project = await _projectService.createDraft(data, token);
      final draftId = project.id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewProjectStep2Screen(
            draftId: draftId,
            previousData: data,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка создания черновика: $e')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingCategories) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
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
              const SizedBox(height: 24),
              const Text(
                'Основная информация',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Заголовок',
                        hintText: 'Введите заголовок проекта',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (val) =>
                      (val == null || val.isEmpty) ? 'Введите заголовок' : null,
                      onChanged: (val) => title = val,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
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
                            specializations.clear();
                            selectedSpecialization = null;
                          });
                          await _loadSpecializations(cat.id);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Категория',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(
                          selectedCategory?.name ?? 'Выберите категорию',
                          style: const TextStyle(fontFamily: 'Inter'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: selectedCategory == null
                          ? null
                          : () async {
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
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Специализация',
                          enabled: selectedCategory != null,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(
                          selectedCategory == null
                              ? 'Сначала выберите категорию'
                              : (selectedSpecialization?.name ??
                              'Выберите специализацию'),
                          style: TextStyle(
                            color: selectedCategory == null
                                ? Palette.thin
                                : Palette.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
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
                      child: isSubmitting
                          ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white))
                          : const Text(
                        'Продолжить',
                        style: TextStyle(
                            color: Palette.white, fontFamily: 'Inter'),
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
                        style:
                        TextStyle(color: Palette.white, fontFamily: 'Inter'),
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