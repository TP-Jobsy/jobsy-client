import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../component/custom_nav_bar.dart';
import '../../../util/palette.dart';

class ExperienceScreen extends StatefulWidget {
  static const List<String> statuses = ['BEGINNER', 'MIDDLE', 'EXPERT'];

  static String labelFor(String code) => _labels[code] ?? code;
  static const Map<String, String> _labels = {
    'BEGINNER': 'Начинающий специалист',
    'MIDDLE': 'Уверенный специалист',
    'EXPERT': 'Опытный профессионал',
  };

  final String? selected;

  const ExperienceScreen({super.key, this.selected});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  String? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selected;
  }

  void _onSave() => Navigator.pop(context, _current);
  void _onCancel() => Navigator.pop(context, widget.selected);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenHeight < 600;

    return Scaffold(
      backgroundColor: Palette.white,
      body: Column(
        children: [
          CustomNavBar(
            leading: InkWell(
              onTap: _onCancel,
              child: SvgPicture.asset(
                'assets/icons/ArrowLeft.svg',
                width: isSmallScreen ? 16 : 20,
                height: isSmallScreen ? 16 : 20,
                color: Palette.black,
              ),
            ),
            title: '',
            trailing: const SizedBox.shrink(),
          ),

          SizedBox(height: isVerySmallScreen ? 15 : 25),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 20 : 31,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Укажите свой опыт работы',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 15,
                  fontWeight: FontWeight.w600,
                  color: Palette.black,
                ),
              ),
            ),
          ),

          SizedBox(height: isVerySmallScreen ? 15 : 25),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: ExperienceScreen.statuses.length,
              separatorBuilder: (_, __) =>
                  SizedBox(height: isVerySmallScreen ? 15 : 25),
              itemBuilder: (ctx, i) {
                final code = ExperienceScreen.statuses[i];
                final label = ExperienceScreen.labelFor(code);
                final isSel = code == _current;

                return Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 31),
                  child: InkWell(
                    onTap: () => setState(() => _current = code),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 12 : 14,
                        horizontal: isSmallScreen ? 14 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Palette.dotInactive),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            isSel
                                ? 'assets/icons/RadioButton2.svg'
                                : 'assets/icons/RadioButton.svg',
                            width: isSmallScreen ? 14 : 16,
                            height: isSmallScreen ? 14 : 16,
                          ),
                          SizedBox(width: isSmallScreen ? 10 : 12),
                          Expanded(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14,
                                color: Palette.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: isVerySmallScreen ? 12 : 20),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 31),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: isSmallScreen ? 45 : 50,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Сохранить изменения',
                      style: TextStyle(
                        color: Palette.white,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                SizedBox(
                  width: double.infinity,
                  height: isSmallScreen ? 45 : 50,
                  child: ElevatedButton(
                    onPressed: _onCancel,
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
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isVerySmallScreen ? 12 : 25),
        ],
      ),
    );
  }
}