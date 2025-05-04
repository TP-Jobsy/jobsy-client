import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/palette.dart';
import 'package:jobsy/provider/freelancer_profile_provider.dart';
import 'package:jobsy/model/freelancer_profile_contact_dto.dart';

class ContactDetailsScreenFree extends StatefulWidget {
  const ContactDetailsScreenFree({super.key});

  @override
  State<ContactDetailsScreenFree> createState() =>
      _ContactDetailsScreenFreeState();
}

class _ContactDetailsScreenFreeState extends State<ContactDetailsScreenFree> {
  late final TextEditingController _linkCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final link =
        context.read<FreelancerProfileProvider>().profile!.contact.contactLink;
    _linkCtrl = TextEditingController(text: link);
  }

  @override
  void dispose() {
    _linkCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final link = _linkCtrl.text.trim();
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
        SnackBar(content: Text(provider.error ?? 'Не удалось сохранить')),
      );
    }
  }

  void _cancel() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Контактные данные'),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
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
              controller: _linkCtrl,
              decoration: InputDecoration(
                labelText: 'Ссылка для связи',
                hintText: 'Ссылка',
                helperText: 'Введите ссылку для связи с вами',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
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
                        : const Text(
                          'Сохранить изменения',
                          style: TextStyle(color: Palette.white, fontFamily: 'Inter'),
                        ),
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
                  style: TextStyle(color: Palette.black, fontFamily: 'Inter'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
