import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../component/error_snackbar.dart';
import '../../model/client_profile_contact_dto.dart';
import '../../provider/client_profile_provider.dart';
import '../../util/palette.dart';

class ContactDetailsScreen extends StatefulWidget {
  const ContactDetailsScreen({super.key});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  late TextEditingController _contactLinkController;

  @override
  void initState() {
    super.initState();
    final existing = context.read<ClientProfileProvider>().profile!.contact.contactLink;
    _contactLinkController = TextEditingController(text: existing);
  }

  @override
  void dispose() {
    _contactLinkController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final prov = context.read<ClientProfileProvider>();
    final dto = ClientProfileContactDto(contactLink: _contactLinkController.text.trim());
    await prov.saveContact(dto);

    if (prov.error != null) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: prov.error!,
      );
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
          icon: SvgPicture.asset('assets/icons/ArrowLeft.svg'),
          onPressed: _cancel,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: _contactLinkController,
              decoration: InputDecoration(
                labelText: 'Ссылка для связи',
                hintText: 'https://example.com',
                helperText: 'Введите корректный HTTP/HTTPS URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                  backgroundColor: Palette.grey3,
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