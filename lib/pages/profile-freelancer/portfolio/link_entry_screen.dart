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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    return Scaffold(
      backgroundColor: Palette.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 24,
                  vertical: isSmallScreen ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomNavBar(
                    title: 'Внешняя ссылка на проект',
                    titleStyle: TextStyle(
                        fontSize: isSmallScreen ? 18 : 22,
                        fontFamily: 'Inter'
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Text(
                    'Вставьте веб-ссылку на статью или веб-сайт',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ссылка',
                      hintStyle: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 12 : 16,
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
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: isSmallScreen ? 8 : 16,
              left: isSmallScreen ? 16 : 24,
              right: isSmallScreen ? 16 : 24,
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
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12 : 14,
                        ),
                      ),
                      child: Text(
                        'Сохранить изменения',
                        style: TextStyle(
                          color: Palette.white,
                          fontSize: isSmallScreen ? 14 : 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: Palette.grey20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12 : 14,
                        ),
                      ),
                      child: Text(
                        'Отмена',
                        style: TextStyle(
                          color: Palette.black,
                          fontSize: isSmallScreen ? 14 : 16,
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