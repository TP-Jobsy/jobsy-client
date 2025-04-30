import 'package:flutter/material.dart';

class ActivityFieldScreen extends StatefulWidget {
  const ActivityFieldScreen({super.key});

  @override
  State<ActivityFieldScreen> createState() => _ActivityFieldScreenState();
}

class _ActivityFieldScreenState extends State<ActivityFieldScreen> {
  final TextEditingController _activityFieldController = TextEditingController();

  @override
  void dispose() {
    _activityFieldController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Логика сохранения данных
    Navigator.pop(context); // Закрытие экрана после сохранения изменений
  }

  void _cancel() {
    Navigator.pop(context); // Отмена и возвращение на предыдущий экран
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Сфера деятельности'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Ввод сферы деятельности
            TextField(
              controller: _activityFieldController,
              decoration: InputDecoration(
                labelText: 'Сфера деятельности',
                hintText: 'Деятельность',
                helperText:
                'Опишите, в какой сфере вы работаете: IT, строительство, маркетинг и т.д.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Spacer(), // Этот Spacer создаст пространство между вводом и кнопками

            // Кнопки сохранения и отмены, расположенные внизу
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2842F7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Сохранить изменения', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _cancel,
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
