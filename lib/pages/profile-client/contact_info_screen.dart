import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../component/custom_nav_bar.dart';
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
      appBar: CustomNavBar(
          titleStyle: TextStyle(fontSize: 22),
          trailing: const SizedBox(width: 30,),
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
          title: 'Контактные данные'
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ссылка для связи',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Palette.black,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'https://example.com',
                      hintStyle: TextStyle(color: Palette.grey3, fontFamily: 'Inter'),
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Palette.grey3, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Palette.grey3),
                      ),
                    ),
                  ),
                ],
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