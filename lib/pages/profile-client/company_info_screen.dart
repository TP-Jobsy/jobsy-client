import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../component/error_snackbar.dart';
import '../../model/profile/client/client_profile_basic_dto.dart';
import '../../provider/client_profile_provider.dart';
import '../../util/palette.dart';

class CompanyInfoScreen extends StatefulWidget {
  const CompanyInfoScreen({super.key});

  @override
  State<CompanyInfoScreen> createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _positionCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _cityCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final basic = context.read<ClientProfileProvider>().profile!.basic;
    _nameCtrl = TextEditingController(text: basic.companyName);
    _positionCtrl = TextEditingController(text: basic.position);
    _countryCtrl = TextEditingController(text: basic.country);
    _cityCtrl = TextEditingController(text: basic.city);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _positionCtrl.dispose();
    _countryCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final country = _countryCtrl.text.trim();
    final city = _cityCtrl.text.trim();

    if (country.isEmpty) {
      _showError('Страна не может быть пустой');
      return;
    }
    if (city.isEmpty) {
      _showError('Город не может быть пустым');
      return;
    }

    setState(() => _saving = true);
    final prof = context.read<ClientProfileProvider>().profile!;
    final basic = prof.basic;

    final dto = ClientProfileBasic(
      firstName: basic.firstName,
      lastName: basic.lastName,
      email: basic.email,
      phone: basic.phone,
      dateBirth: prof.user.dateBirth,
      companyName: _nameCtrl.text.trim(),
      position: _positionCtrl.text.trim(),
      country: country,
      city: city,
    );

    await context.read<ClientProfileProvider>().saveBasic(dto);
    final err = context.read<ClientProfileProvider>().error;
    setState(() => _saving = false);

    if (err == null) {
      Navigator.pop(context);
    } else {
      _showError(err);
    }
  }

  void _showError(String msg) {
    ErrorSnackbar.show(
      context,
      type: ErrorType.error,
      title: 'Ошибка',
      message: msg,
    );
  }

  Widget _buildField(
      String label,
      TextEditingController ctrl, {
        String hint = '',
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
          decoration: InputDecoration(
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.grey3, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.grey3),
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
        title: 'Данные компании',
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
                      _buildField('Название компании', _nameCtrl,
                          hint: 'ООО Ромашка'),
                      _buildField('Должность', _positionCtrl,
                          hint: 'Менеджер проектов'),
                      _buildField('Страна', _countryCtrl, hint: 'Россия'),
                      _buildField('Город', _cityCtrl, hint: 'Москва'),
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
          child: SizedBox(
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
        ),
      ),
    );
  }
}