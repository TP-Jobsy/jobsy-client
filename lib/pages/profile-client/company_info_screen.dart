import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/client_profile_basic_dto.dart';
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

    final dto = ClientProfileBasicDto(
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Данные компании'),
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            _buildField('Название компании', _nameCtrl, hint: 'ООО Ромашка'),
            _buildField('Должность', _positionCtrl, hint: 'Менеджер проектов'),
            _buildField('Страна', _countryCtrl, hint: 'Россия'),
            _buildField('Город', _cityCtrl, hint: 'Москва'),
            const Spacer(),
            ElevatedButton(
              onPressed: _saving ? null : _saveChanges,
              child:
                  _saving
                      ? const CircularProgressIndicator(color: Palette.white)
                      : const Text('Сохранить изменения',
                      style: TextStyle(color: Palette.white, fontSize: 16, fontFamily: 'Inter')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primary,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    String hint = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontFamily: 'Inter')),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
