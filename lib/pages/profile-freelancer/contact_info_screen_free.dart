import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../util/palette.dart';
import 'package:jobsy/provider/freelancer_profile_provider.dart';
import '../../component/error_snackbar.dart';
import '../../model/profile/free/freelancer_profile_contact_dto.dart';

class ContactInfoScreenFree extends StatefulWidget {
  const ContactInfoScreenFree({Key? key}) : super(key: key);

  @override
  State<ContactInfoScreenFree> createState() => _ContactInfoScreenFreeState();
}

class _ContactInfoScreenFreeState extends State<ContactInfoScreenFree> {
  final _formKey = GlobalKey<FormState>();
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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final provider = context.read<FreelancerProfileProvider>();
    final dto = FreelancerProfileContact(contactLink: _contactLinkController.text.trim());
    final ok = await provider.updateContact(dto);
    setState(() => _saving = false);

    if (ok) {
      Navigator.pop(context);
    } else {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: provider.error!,
      );
    }
  }

  void _cancel() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        titleStyle: const TextStyle(fontSize: 22),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: _cancel,
        ),
        title: 'Контактные данные',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ссылка для связи',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Palette.black,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contactLinkController,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'https://example.com',
                        hintStyle: const TextStyle(color: Palette.grey3, fontFamily: 'Inter'),
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.grey3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.grey3, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ссылка не может быть пустой';
                        }
                        if (!value.trim().startsWith('https://')) {
                          return 'Ссылка должна начинаться с https://';
                        }
                        return null;
                      },
                    ),
                  ],
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
                  child: _saving
                      ? const CircularProgressIndicator(color: Palette.white)
                      : const Text(
                    'Сохранить изменения',
                    style: TextStyle(
                      color: Palette.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
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
                    style: TextStyle(
                      color: Palette.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
