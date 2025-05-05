import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../model/skill/skill.dart';
import '../skill_search/skill_search_screen.dart';
import '../../../util/palette.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<Skill> _selectedSkills = [];

  Future<void> _openSkillSearch() async {
    final Skill? skill = await Navigator.push<Skill>(
      context,
      MaterialPageRoute(builder: (_) => const SkillSearchScreen()),
    );
    if (skill != null && !_selectedSkills.any((s) => s.id == skill.id)) {
      setState(() => _selectedSkills.add(skill));
    }
  }

  void _removeSkill(Skill s) {
    setState(() => _selectedSkills.removeWhere((e) => e.id == s.id));
  }

  void _clearAll() {
    setState(() => _selectedSkills.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomNavBar(
          title: 'Фильтр',
          titleStyle: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Palette.black
          ),
          trailing: GestureDetector(
            onTap: _clearAll,
            child: const Text(
              'Очистить',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500,
                  color: Palette.dotActive, fontFamily: 'Inter'
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _openSkillSearch,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Palette.dotInactive),
                  boxShadow: [
                    BoxShadow(
                        color: Palette.black.withOpacity(0.1),
                        spreadRadius: 1, blurRadius: 2, offset: const Offset(0,2)
                    )
                  ],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                        'assets/icons/Search.svg',
                        width: 16, height: 16, color: Palette.navbar
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Поиск',
                      style: TextStyle(color: Palette.grey3, fontFamily: 'Inter'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Навыки',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Inter'
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _selectedSkills.map((skill) {
                return Chip(
                  label: Text(skill.name),
                  deleteIcon: SvgPicture.asset(
                    'assets/icons/Close.svg',
                    width: 15, height: 15,
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
            const Spacer(),
          ],
        ),
      ),
    );
  }
}