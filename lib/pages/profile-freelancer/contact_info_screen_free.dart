import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/palette.dart';
import 'package:jobsy/provider/freelancer_profile_provider.dart';
import 'package:jobsy/model/freelancer_profile_contact_dto.dart';

class ContactInfoScreenFree extends StatefulWidget {
  const ContactInfoScreenFree({super.key});

  @override
  State<ContactInfoScreenFree> createState() => _ContactInfoScreenFreeState();
}

class _ContactInfoScreenFreeState extends State<ContactInfoScreenFree> {
  late final TextEditingController _contactLinkController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final prof = context.read<FreelancerProfileProvider>().profile!;
    _contactLinkController = TextEditingController(
      text: prof.contact.contactLink,
    );
  }

  @override
  void dispose() {
    _contactLinkController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final link = _contactLinkController.text.trim();
    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ссылка не может быть пустой')),
      );
      return;
    }

    setState(() => _saving = true);
    final provider = context.read<FreelancerProfileProvider>();
    final dto = FreelancerProfileContactDto(contactLink: link);
    final ok = await provider.updateContact(dto);
    setState(() => _saving = false);

    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Ошибка сохранения')),
      );
    }
  }

  void _cancel() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Контактные данные'),
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child:
                    _saving
                        ? const CircularProgressIndicator(color: Palette.white)
                        : const Text('Сохранить изменения'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _cancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.grey20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Отмена',
                  style: TextStyle(color: Palette.black, fontFamily: "Inter"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
