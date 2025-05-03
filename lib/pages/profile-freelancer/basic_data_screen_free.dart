import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/palette.dart';
import 'package:jobsy/provider/freelancer_profile_provider.dart';
import 'package:jobsy/model/freelancer_profile_basic_dto.dart';

class BasicDataScreenFree extends StatefulWidget {
  const BasicDataScreenFree({super.key});

  @override
  State<BasicDataScreenFree> createState() => _BasicDataScreenFreeState();
}

class _BasicDataScreenFreeState extends State<BasicDataScreenFree> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _cityCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final basic = context.read<FreelancerProfileProvider>().profile!.basic;
    _firstNameCtrl = TextEditingController(text: basic.firstName);
    _lastNameCtrl = TextEditingController(text: basic.lastName);
    _emailCtrl = TextEditingController(text: basic.email);
    _phoneCtrl = TextEditingController(text: basic.phone);
    _countryCtrl = TextEditingController(text: basic.country);
    _cityCtrl = TextEditingController(text: basic.city);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _countryCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final firstName = _firstNameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final country = _countryCtrl.text.trim();
    final city = _cityCtrl.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Имя, фамилия и телефон обязательны')),
      );
      return;
    }

    setState(() => _saving = true);
    final provider = context.read<FreelancerProfileProvider>();
    final dto = FreelancerProfileBasicDto(
      firstName: firstName,
      lastName: lastName,
      email: provider.profile!.basic.email,
      phone: phone,
      dateBirth: provider.profile!.basic.dateBirth,
      country: country,
      city: city,
    );

    final ok = await provider.updateBasic(dto);
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Palette.grey3,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Palette.grey3,
              ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            _buildField('Имя', _firstNameCtrl),
            _buildField('Фамилия', _lastNameCtrl),
            _buildField('Почта', _emailCtrl, readOnly: true),
            _buildField('Номер телефона', _phoneCtrl),
            _buildField('Страна', _countryCtrl),
            _buildField('Город', _cityCtrl),
            const Spacer(),
            Column(
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
                    child:
                        _saving
                            ? const CircularProgressIndicator(
                              color: Palette.white,
                            )
                            : const Text(
                              'Сохранить изменения',
                              style: TextStyle(color: Palette.white, fontSize: 16, fontFamily: 'Inter'),
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
                      style: TextStyle(color: Palette.black, fontSize: 16, fontFamily: 'Inter'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
