import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../model/skill/skill.dart';
import '../skill_search/skill_search_screen.dart';
import '../../../util/palette.dart';

class FilterScreen extends StatefulWidget {
  final List<Skill> initialSelected;

  const FilterScreen({super.key, this.initialSelected = const []});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late List<Skill> _selectedSkills;

  @override
  void initState() {
    super.initState();
    _selectedSkills = List.from(widget.initialSelected);
  }

  Future<void> _openSkillSearch() async {
    final Skill? skill = await Navigator.push<Skill>(
      context,
      MaterialPageRoute(builder: (_) => const SkillSearchScreen()),
    );
    if (skill != null && !_selectedSkills.any((s) => s.id == skill.id)) {
      setState(() => _selectedSkills.add(skill));
    }
  }

  void _removeSkill(Skill s) =>
      setState(() => _selectedSkills.removeWhere((e) => e.id == s.id));

  void _clearAll() {
    Navigator.of(context).pop(<Skill>[]);
  }

  void _applyFilter() {
    Navigator.of(context).pop(_selectedSkills);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    final paddingH = isSmallScreen ? 16.0 : 24.0;
    final inputHeight = isSmallScreen ? 44.0 : 48.0;
    final chipFontSize = isSmallScreen ? 13.0 : 14.0;
    final buttonPaddingV = isSmallScreen ? 11.0 : 13.0;
    final buttonPaddingH = isSmallScreen ? 40.0 : 50.0;
    final buttonFontSize = isSmallScreen ? 13.0 : 14.0;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomNavBar(
          title: 'Фильтр',
          titleStyle: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w500,
            color: Palette.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _openSkillSearch,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: inputHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Palette.dotInactive),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Search.svg',
                      width: isSmallScreen ? 14 : 16,
                      height: isSmallScreen ? 14 : 16,
                      color: Palette.navbar,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Поиск',
                      style: TextStyle(
                        color: Palette.grey3,
                        fontSize: chipFontSize,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Навыки',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedSkills.map((skill) {
                    return Chip(
                      label: Text(
                        skill.name,
                        style: TextStyle(fontSize: chipFontSize),
                      ),
                      deleteIcon: SvgPicture.asset(
                        'assets/icons/Close.svg',
                        width: isSmallScreen ? 13 : 15,
                        height: isSmallScreen ? 13 : 15,
                        color: Palette.black,
                      ),
                      onDeleted: () => _removeSkill(skill),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Palette.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Palette.white,
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: _clearAll,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPaddingH,
                        vertical: buttonPaddingV,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.sky,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Очистить',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w500,
                          color: Palette.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _applyFilter,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPaddingH,
                        vertical: buttonPaddingV,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Сохранить',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w500,
                          color: Palette.white,
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
