import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../component/progress_step_indicator.dart';
import '../../../model/skill/skill.dart';
import '../skill_search/skill_search_screen.dart';
import '../../../util/palette.dart';
import 'new_project_step6_screen.dart';

class NewProjectStep5Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const NewProjectStep5Screen({super.key, required this.previousData});

  @override
  State<NewProjectStep5Screen> createState() => _NewProjectStep5ScreenState();
}

class _NewProjectStep5ScreenState extends State<NewProjectStep5Screen> {
  final List<Skill> selectedSkills = [];

  Future<void> _openSkillSearch() async {
    final Skill? skill = await Navigator.push<Skill>(
      context,
      MaterialPageRoute(builder: (_) => const SkillSearchScreen()),
    );
    if (skill != null && selectedSkills.every((s) => s.id != skill.id)) {
      setState(() {
        selectedSkills.add(skill);
      });
    }
  }

  void _removeSkill(Skill skill) {
    setState(() {
      selectedSkills.removeWhere((s) => s.id == skill.id);
    });
  }

  void _goToStep6() {
    final updatedData = {
      ...widget.previousData,
      // передаём только id
      'skills': selectedSkills.map((s) => s.id).toList(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NewProjectStep6Screen(previousData: updatedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Требуемые навыки'),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressStepIndicator(totalSteps: 6, currentStep: 4),
            const SizedBox(height: 24),
            const Text(
              'Требуемые навыки',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            // поле, которое открывает экран поиска
            InkWell(
              onTap: _openSkillSearch,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 48,
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Palette.dotInactive),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Palette.grey3),
                    SizedBox(width: 8),
                    Text(
                      'Поиск навыков',
                      style: TextStyle(color: Palette.grey3, fontFamily: 'Inter'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Добавленные навыки',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedSkills.map((skill) {
                return Chip(
                  label: Text(skill.name),
                  deleteIcon: const Icon(Icons.close),
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
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: selectedSkills.isEmpty ? null : _goToStep6,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Продолжить',
                      style: TextStyle(
                        color: Palette.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.grey3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Назад',
                      style: TextStyle(
                        color: Palette.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
