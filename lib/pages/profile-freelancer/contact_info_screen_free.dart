import 'package:flutter/material.dart';

class ContactInfoScreenFree extends StatefulWidget {
  const ContactInfoScreenFree({super.key});

  @override
  State<ContactInfoScreenFree> createState() => _ContactInfoScreenFreeState();
}

class _ContactInfoScreenFreeState extends State<ContactInfoScreenFree> {
  final TextEditingController _contactLinkController = TextEditingController();

  @override
  void dispose() {
    _contactLinkController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Navigator.pop(context);
  }

  void _cancel() {
    Navigator.pop(context);
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
            TextField(
              controller: _contactLinkController,
              decoration: const InputDecoration(
                labelText: 'Ссылка для связи',
                hintText: 'Ссылка',
              ),
            ),
            const Spacer(),
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
            )
          ],
        ),
      ),
    );
  }
}
