import 'package:flutter/material.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../util/palette.dart';

class LinkEntryScreen extends StatefulWidget {
  const LinkEntryScreen({super.key});

  @override
  State<LinkEntryScreen> createState() => _LinkEntryScreenState();
}

class _LinkEntryScreenState extends State<LinkEntryScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final link = _controller.text.trim();
    Navigator.of(context).pop(link);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomNavBar(
                    title: 'Cсылка на проект',
                    titleStyle: TextStyle(fontSize: 22, fontFamily: 'Inter'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Вставьте веб-ссылку на статью или веб-сайт',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ссылка',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Palette.grey3, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Palette.grey3),
                      ),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
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
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: Palette.grey20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
          ],
        ),
      ),
    );
  }
}
