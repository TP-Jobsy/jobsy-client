import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../component/progress_step_indicator.dart';
import '../../../model/category/category.dart';
import '../../../model/project/project_create.dart';
import '../../../model/skill/skill.dart';
import '../../../model/specialization/specialization.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';
import '../projects_screen.dart';

class NewProjectStep6Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const NewProjectStep6Screen({super.key, required this.previousData});

  @override
  State<NewProjectStep6Screen> createState() => _NewProjectStep6ScreenState();
}

class _NewProjectStep6ScreenState extends State<NewProjectStep6Screen> {
  final _projectService = ProjectService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _generateDescription() {
    _descriptionController.text =
    'Это пример описания проекта. Укажите цели, задачи, сроки, ожидания и требования к исполнителю.';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка: не найден токен')),
      );
      setState(() => isSubmitting = false);
      return;
    }

    final raw = widget.previousData['fixedPrice'];
    final fixedPrice = (raw is num)
        ? raw.toDouble()
        : double.tryParse(raw.toString()) ?? 0.0;
    if (fixedPrice < 0.01) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сумма должна быть не менее 0.01')),
      );
      setState(() => isSubmitting = false);
      return;
    }

    final diffLabel = widget.previousData['difficulty'] as String? ?? '';
    final complexityStr = {
      'Простой': 'EASY',
      'Средний': 'MEDIUM',
      'Сложный': 'HARD',
    }[diffLabel] ?? 'MEDIUM';

    final deadlineLabel = widget.previousData['deadline'] as String? ?? '';
    final durationStr = {
      'Менее 1 месяца': 'LESS_THAN_1_MONTH',
      'От 1 до 3 месяцев': 'LESS_THAN_3_MONTHS',
      'От 3 до 6 месяцев': 'LESS_THAN_6_MONTHS',
    }[deadlineLabel] ?? 'LESS_THAN_1_MONTH';

    final dto = ProjectCreate(
      title: widget.previousData['title'] as String,
      description: _descriptionController.text.trim(),
      complexity: complexityStr,
      paymentType: 'FIXED',
      fixedPrice: fixedPrice,
      duration: durationStr,
      category: widget.previousData['category'] as Category,
      specialization:
      widget.previousData['specialization'] as Specialization,
      skills: (widget.previousData['skills'] as List<int>)
          .map((id) => Skill(id: id, name: ''))
          .toList(),
    );

    try {
      await _projectService.createProject(dto.toJson(), token);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Проект успешно создан')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const ProjectsScreen()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при создании проекта: $e')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              const ProgressStepIndicator(totalSteps: 6, currentStep: 5),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Описание проекта',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                minLines: 5,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Опишите задачи, сроки, требования...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 30) {
                    return 'Описание должно быть не менее 30 символов';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _generateDescription,
                  child: const Text(
                    'Сгенерировать AI',
                    style: TextStyle(
                        color: Palette.primary, fontFamily: 'Inter'),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: isSubmitting
                          ? const CircularProgressIndicator(
                        color: Palette.white,
                      )
                          : const Text(
                        'Создать проект',
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
                      onPressed:
                      isSubmitting ? null : () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.grey3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Назад',
                        style: TextStyle(
                            color: Palette.white, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
