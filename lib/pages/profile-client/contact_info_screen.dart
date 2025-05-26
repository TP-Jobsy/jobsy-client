import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../component/custom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../model/profile/client/client_profile_contact_dto.dart';
import '../../provider/client_profile_provider.dart';
import '../../util/palette.dart';

class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final _formKey = GlobalKey<FormState>();
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
    if (!_formKey.currentState!.validate()) return;

    final prov = context.read<ClientProfileProvider>();
    final dto = ClientProfileContact(
      contactLink: _contactLinkController.text.trim(),
    );

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

  Widget _buildTextField() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ссылка для связи',
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            color: Palette.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _contactLinkController,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'https://example.com ',
            hintStyle: const TextStyle(
              color: Palette.grey3,
              fontFamily: 'Inter',
            ),
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.grey3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.grey3, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.red),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Введите ссылку';
            }
            if (!value.trim().startsWith('https://')) {
              return 'Ссылка должна начинаться с https://';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen = screenHeight < 700;

    final loading = context.watch<ClientProfileProvider>().loading;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: 'Контактные данные',
        titleStyle: TextStyle(
          fontSize: screenWidth < 360 ? 20 : 22,
          fontFamily: 'Inter',
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: _cancel,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth < 360 ? 16 : 24,
                vertical: 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildTextField(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth < 360 ? 16 : 24,
            0,
            screenWidth < 360 ? 16 : 24,
            10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      : Text(
                    'Сохранить изменения',
                    style: TextStyle(
                      color: Palette.white,
                      fontSize: isSmallScreen ? 15 : 16,
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
                  onPressed: loading ? null : _cancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.grey20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Отмена',
                    style: TextStyle(
                      color: Palette.black,
                      fontSize: isSmallScreen ? 15 : 16,
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