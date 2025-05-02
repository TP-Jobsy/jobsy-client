import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/client_profile_field_dto.dart';
import '../../provider/client_profile_provider.dart';

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
    final dto = ClientProfileFieldDto(fieldDescription: _fieldCtrl.text);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Сфера деятельности'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _cancel),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: _fieldCtrl,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Описание сферы',
                hintText: 'Опишите вашу деятельность',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
                      backgroundColor: const Color(0xFF2842F7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: _saving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Сохранить изменения', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _cancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Отмена', style: TextStyle(color: Colors.black)),
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