import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../component/custom_nav_bar.dart';
import '../../../util/palette.dart';

class ExperienceScreen extends StatefulWidget {
  static const List<String> statuses = ['BEGINNER', 'MIDDLE', 'EXPERT'];

  /// Для отображения человеко-читаемого текста
  static String labelFor(String code) => _labels[code] ?? code;
  static const Map<String, String> _labels = {
    'BEGINNER': 'Начинающий специалист',
    'MIDDLE':   'Уверенный специалист',
    'EXPERT':   'Опытный профессионал',
  };

  final String? selected;

  const ExperienceScreen({Key? key, this.selected}) : super(key: key);

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

  void _onSave()   => Navigator.pop(context, _current);
  void _onCancel() => Navigator.pop(context, widget.selected);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Column(
        children: [
          // Навбар с чёрной стрелкой и без заголовка
          CustomNavBar(
            leading: InkWell(
              onTap: _onCancel,
              child: SvgPicture.asset(
                'assets/icons/ArrowLeft.svg',
                width: 24,
                height: 24,
                // убираем серый фильтр, ставим чёрный
                color: Palette.black,
              ),
            ),
            title: '', // нет текста внутри самого бара
            trailing: const SizedBox.shrink(),
          ),

          // Отступ сверху 25px
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 31),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Укажите свой опыт работы',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Palette.black,
                ),
              ),
            ),
          ),

          // Отступ 25px и список опций
          const SizedBox(height: 25),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: ExperienceScreen.statuses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 25),
              itemBuilder: (ctx, i) {
                final code  = ExperienceScreen.statuses[i];
                final label = ExperienceScreen.labelFor(code);
                final isSel = code == _current;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 31),
                  child: InkWell(
                    onTap: () => setState(() => _current = code),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
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
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 14,
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

          // Кнопки «Сохранить» / «Отмена»
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 31),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Сохранить изменения',
                      style: TextStyle(color: Palette.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.grey20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Отмена',
                      style: TextStyle(color: Palette.black, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}