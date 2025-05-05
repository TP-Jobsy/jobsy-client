import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../model/profile/client/client_profile_contact_dto.dart';
import '../../provider/client_profile_provider.dart';
import '../../util/palette.dart';

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
    final existingLink = context.read<ClientProfileProvider>().profile?.contact.contactLink ?? '';
    _contactLinkController = TextEditingController(text: existingLink);
  }

  @override
  void dispose() {
    _contactLinkController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final prov = context.read<ClientProfileProvider>();
    final dto = ClientProfileContact(
      contactLink: _contactLinkController.text.trim(),
    );
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
    final loading = context.watch<ClientProfileProvider>().loading;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Контактные данные'),
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
          onPressed: () {
            Navigator.pop(context);
          },
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
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Palette.white)
                    : const Text('Сохранить изменения', style: TextStyle(color: Palette.white, fontSize: 16, fontFamily: 'Inter')),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : _cancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.grey20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Отмена', style: TextStyle(color: Palette.black, fontSize: 16, fontFamily: 'Inter')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}