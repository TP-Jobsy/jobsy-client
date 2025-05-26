import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../component/custom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../model/profile/client/client_profile_basic_dto.dart';
import '../../provider/client_profile_provider.dart';
import '../../util/palette.dart';

class BasicDataScreen extends StatefulWidget {
  const BasicDataScreen({super.key});

  @override
  State<BasicDataScreen> createState() => _BasicDataScreenState();
}

class _BasicDataScreenState extends State<BasicDataScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _surnameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final basic = context.read<ClientProfileProvider>().profile!.basic;
    _nameCtrl = TextEditingController(text: basic.firstName);
    _surnameCtrl = TextEditingController(text: basic.lastName);
    _emailCtrl = TextEditingController(text: basic.email);
    String phoneDigits = basic.phone;
    if (phoneDigits.startsWith('7')) {
      phoneDigits = phoneDigits.substring(1);
    }
    _phoneCtrl = TextEditingController(text: phoneDigits);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final name = _nameCtrl.text.trim();
    final surname = _surnameCtrl.text.trim();
    final phonePart = _phoneCtrl.text.trim();

    if (name.isEmpty) {
      _showError('Имя не может быть пустым');
      return;
    }
    if (surname.isEmpty) {
      _showError('Фамилия не может быть пустой');
      return;
    }
    if (phonePart.isEmpty || phonePart.length != 10) {
      _showError('Номер телефона должен содержать 10 цифр');
      return;
    }

    final fullPhone = '7$phonePart';
    setState(() => _saving = true);
    final prof = context.read<ClientProfileProvider>().profile!;
    final dto = ClientProfileBasic(
      firstName: name,
      lastName: surname,
      email: prof.basic.email,
      phone: fullPhone,
      dateBirth: prof.user.dateBirth,
      companyName: prof.basic.companyName,
      position: prof.basic.position,
      country: prof.basic.country,
      city: prof.basic.city,
    );
    await context.read<ClientProfileProvider>().saveBasic(dto);

    final err = context.read<ClientProfileProvider>().error;
    setState(() => _saving = false);

    if (err == null) {
      Navigator.of(context).pop();
    } else {
      _showError(err);
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _showError(String message) {
    ErrorSnackbar.show(
      context,
      type: ErrorType.error,
      title: 'Ошибка',
      message: message,
    );
  }

  Widget _buildField(
      String label,
      TextEditingController ctrl, {
        bool readOnly = false,
        List<TextInputFormatter>? inputFormatters,
        TextInputType? keyboardType,
        String? prefixText,
      }) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          readOnly: readOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            prefixText: prefixText,
            filled: readOnly,
            fillColor: readOnly ? Palette.white : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Palette.grey3, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Palette.grey3),
            ),
          ),
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

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: 'Основные данные',
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
          onPressed: () => Navigator.pop(context),
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
                  child: Column(
                    children: [
                      _buildField('Имя', _nameCtrl),
                      _buildField('Фамилия', _surnameCtrl),
                      _buildField('Почта', _emailCtrl, readOnly: true),
                      _buildField(
                        'Номер телефона',
                        _phoneCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        prefixText: '+7 ',
                      ),
                    ],
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
                  onPressed: _saving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _saving
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
                  onPressed: _saving ? null : _cancel,
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