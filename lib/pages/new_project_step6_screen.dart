import 'package:flutter/material.dart';
// import 'new_project_preview_screen.dart'; // если есть финальный просмотр

class NewProjectStep6Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const NewProjectStep6Screen({super.key, required this.previousData});

  @override
  State<NewProjectStep6Screen> createState() => _NewProjectStep6ScreenState();
}

class _NewProjectStep6ScreenState extends State<NewProjectStep6Screen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _generateWithAI() {
    setState(() {
      _descriptionController.text = 'Это пример описания проекта, сгенерированный автоматически. Вы можете отредактировать его при необходимости.';
      _showError = false;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        ...widget.previousData,
        'final_description': _descriptionController.text.trim(),
      };

      // TODO: заменить на переход на просмотр или публикацию
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Проект почти готов!')),
      );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => NewProjectPreviewScreen(projectData: updatedData),
      //   ),
      // );
    } else {
      setState(() {
        _showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Новый проект'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressIndicator(),
              const SizedBox(height: 24),
              const Text(
                'Описание проекта',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('Описание', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Expanded(
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Опишите задачу, основные требования, важные детали',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 30) {
                      return 'Текст должен быть не менее 30 символов';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _generateWithAI,
                  child: const Text(
                    'Сгенерировать с помощью AI',
                    style: TextStyle(color: Color(0xFF2842F7)),
                  ),
                ),
              ),
              if (_showError)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Неверный ввод\nТекст должен быть не менее 30 символов',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2842F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Продолжить', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Назад', style: TextStyle(color: Colors.white)),
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

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 32,
          height: 6,
          decoration: BoxDecoration(
            color: index == 5 ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
