import 'package:flutter/material.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../util/palette.dart';

class LinkEntryScreen extends StatefulWidget {
  const LinkEntryScreen({super.key});

  @override
  State<LinkEntryScreen> createState() => _LinkEntryScreenState();
}

class _LinkEntryScreenState extends State<LinkEntryScreen> {
  final _contactLinkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isValidLink = false;

  @override
  void dispose() {
    _contactLinkController.dispose();
    super.dispose();
  }

  void _validateLink(String value) {
    final trimmedValue = value.trim();
    setState(() {
      _isValidLink = _isValidUrl(trimmedValue);
    });
  }

  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final link = _contactLinkController.text.trim();
    Navigator.of(context).pop(link);
  }

  String? _urlValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите ссылку';
    }
    if (!_isValidUrl(value)) {
      return 'Введите корректную ссылку (начинается с http:// или https://)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: Palette.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                      title: 'Ссылка на проект',
                      titleStyle: TextStyle(
                          fontSize: isSmallScreen ? 18 : 22,
                          fontFamily: 'Inter'),
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
                    TextFormField(
                      controller: _contactLinkController,
                      minLines: 1,
                      maxLines: 5,
                      validator: _urlValidator,
                      onChanged: _validateLink,
                      decoration: InputDecoration(
                        hintText: 'https://example.com',
                        hintStyle: const TextStyle(
                            color: Palette.grey3, fontFamily: 'Inter'),
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5),
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
                        onPressed: _isValidLink ? _save : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isValidLink
                              ? Palette.primary
                              : Palette.grey3,
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
      ),
    );
  }
}