import 'package:flutter/material.dart';
import 'package:jobsy/util/pallete.dart';
import '../../component/progress_step_indicator.dart';
import 'projects_screen.dart';

class NewProjectStep6Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const NewProjectStep6Screen({super.key, required this.previousData});

  @override
  State<NewProjectStep6Screen> createState() => _NewProjectStep6ScreenState();
}

class _NewProjectStep6ScreenState extends State<NewProjectStep6Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _generateDescription() {
    _descriptionController.text =
    'Это пример описания проекта. Укажите цели, задачи, дедлайн и требования к исполнителю.';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final project = {
        ...widget.previousData,
        'description': _descriptionController.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => ProjectsScreen(initialProject: project),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый проект'),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                ),
              ),
              const SizedBox(height: 25),
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
                  child: const Text('Сгенерировать с помощью AI',
                      style: TextStyle(color: Palette.primary, fontFamily: 'Inter')),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Продолжить', style: TextStyle(color: Palette.white, fontFamily: 'Inter')),
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
                      child: const Text('Назад', style: TextStyle(color: Palette.white, fontFamily: 'Inter')),
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
