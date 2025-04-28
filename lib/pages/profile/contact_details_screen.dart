import 'package:flutter/material.dart';

class ContactDetailsScreen extends StatefulWidget {
  const ContactDetailsScreen({super.key});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  final TextEditingController _contactLinkController = TextEditingController();

  @override
  void dispose() {
    _contactLinkController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Логика для сохранения данных
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
        title: const Text('Контактные данные'),
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
            // Ввод ссылки для связи
            TextField(
              controller: _contactLinkController,
              decoration: InputDecoration(
                labelText: 'Ссылка для связи',
                hintText: 'Ссылка',
                helperText: 'Введите ссылку для связи с вами',
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
