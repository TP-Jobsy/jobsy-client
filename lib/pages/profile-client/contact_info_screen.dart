import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/client_profile_contact_dto.dart';
import '../../provider/profile_provider.dart';

class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  late TextEditingController _contactLinkController;

  @override
  void initState() {
    super.initState();
    final existingLink = context.read<ProfileProvider>().profile?.contact.contactLink ?? '';
    _contactLinkController = TextEditingController(text: existingLink);
  }

  @override
  void dispose() {
    _contactLinkController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final prov = context.read<ProfileProvider>();
    // Собираем DTO
    final dto = ClientProfileContactDto(
      contactLink: _contactLinkController.text.trim(),
    );
    // Отправляем
    await prov.saveContact(dto);

    if (prov.error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(prov.error!)));
    } else {
      Navigator.pop(context);
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<ProfileProvider>().loading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Контактные данные'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _cancel,
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
                hintText: 'https://example.com',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2842F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Сохранить изменения', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : _cancel,
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
      ),
    );
  }
}