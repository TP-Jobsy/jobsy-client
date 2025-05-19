import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../model/profile/client/client_profile_field_dto.dart';
import '../../provider/client_profile_provider.dart';
import '../../util/palette.dart';

class ActivityFieldScreen extends StatefulWidget {
  const ActivityFieldScreen({super.key});

  @override
  State<ActivityFieldScreen> createState() => _ActivityFieldScreenState();
}

class _ActivityFieldScreenState extends State<ActivityFieldScreen> {
  late TextEditingController _fieldCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final desc = context.read<ClientProfileProvider>().profile!.field.fieldDescription;
    _fieldCtrl = TextEditingController(text: desc);
  }

  @override
  void dispose() {
    _fieldCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _saving = true);
    final dto = ClientProfileField(fieldDescription: _fieldCtrl.text);
    await context.read<ClientProfileProvider>().saveField(dto);
    final err = context.read<ClientProfileProvider>().error;
    setState(() => _saving = false);
    if (err == null) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  void _cancel() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title:'Сфера деятельности',
        titleStyle: TextStyle(fontSize: 22),
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
        trailing: const SizedBox(width: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: _fieldCtrl,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Опишите вашу деятельность',
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: _saving
                        ? const CircularProgressIndicator(color: Palette.white)
                        : const Text('Сохранить изменения', style: TextStyle(color: Palette.white, fontSize: 16, fontFamily: 'Inter')),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _cancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.grey20,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Отмена', style: TextStyle(color: Palette.black, fontSize: 16, fontFamily: 'Inter')),
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