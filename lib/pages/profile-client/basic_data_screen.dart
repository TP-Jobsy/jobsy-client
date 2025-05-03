import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/client_profile_basic_dto.dart';
import '../../provider/client_profile_provider.dart';
import '../../util/palette.dart';

class BasicDataScreen extends StatefulWidget {
  const BasicDataScreen({Key? key}) : super(key: key);

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
    _phoneCtrl = TextEditingController(text: basic.phone);
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
    final phone = _phoneCtrl.text.trim();

    if (name.isEmpty) {
      _showError('Имя не может быть пустым');
      return;
    }
    if (surname.isEmpty) {
      _showError('Фамилия не может быть пустой');
      return;
    }
    if (phone.isEmpty) {
      _showError('Телефон не может быть пустым');
      return;
    }

    setState(() => _saving = true);
    final prof = context.read<ClientProfileProvider>().profile!;
    final dto = ClientProfileBasicDto(
      firstName: name,
      lastName: surname,
      email: prof.basic.email,
      phone: phone,
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

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Widget _buildField(
      String label,
      TextEditingController ctrl, {
        bool readOnly = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontFamily: 'Inter')),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: readOnly,
            fillColor: readOnly ? Palette.white : null,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Основные данные'),
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField('Имя', _nameCtrl),
              _buildField('Фамилия', _surnameCtrl),
              _buildField('Почта', _emailCtrl, readOnly: true),
              _buildField('Номер телефона', _phoneCtrl),
              const Spacer(),

              ElevatedButton(
                onPressed: _saving ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _saving
                    ? const CircularProgressIndicator(
                  color: Palette.white,
                )
                    : const Text(
                  'Сохранить изменения',
                  style: TextStyle(fontSize: 16, color: Palette.white, fontFamily: 'Inter'),
                ),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: _saving ? null : _cancel,
                style: TextButton.styleFrom(
                  backgroundColor: Palette.grey20,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Отмена',
                  style: TextStyle(fontSize: 16, color: Palette.black, fontFamily: 'Inter' ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}