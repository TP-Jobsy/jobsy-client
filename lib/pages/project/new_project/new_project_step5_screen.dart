import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../component/progress_step_indicator.dart';
import '../../../model/skill/skill.dart';
import '../../../service/project_service.dart';
import '../skill_search/skill_search_screen.dart';
import '../../../util/palette.dart';
import 'new_project_step6_screen.dart';
import '../../../component/error_snackbar.dart';

class NewProjectStep5Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;
  final int draftId;

  const NewProjectStep5Screen({
    Key? key,
    required this.draftId,
    required this.previousData,
  }) : super(key: key);

  @override
  _NewProjectStep5ScreenState createState() => _NewProjectStep5ScreenState();
}

class _NewProjectStep5ScreenState extends State<NewProjectStep5Screen> {
  late final ProjectService _projectService;
  final List<Skill> _selectedSkills = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _projectService = context.read<ProjectService>();
  }

  Future<void> _onContinue() async {
    if (_selectedSkills.isEmpty) return;
    setState(() => _isLoading = true);

    final updated = {
      ...widget.previousData,
      'skills': _selectedSkills.map((s) => {'id': s.id}).toList(),
    };

    try {
      await _projectService.updateDraft(widget.draftId, updated);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => NewProjectStep6Screen(
                draftId: widget.draftId,
                previousData: updated,
              ),
        ),
      );
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка сохранения навыков',
        message: '$e',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openSkillSearch() async {
    if (_selectedSkills.length >= 5) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: 'Нельзя добавить более 5 навыков',
      );
      return;
    }

    final Skill? skill = await Navigator.push<Skill>(
      context,
      MaterialPageRoute(builder: (_) => const SkillSearchScreen()),
    );
    if (skill != null && _selectedSkills.every((s) => s.id != skill.id)) {
      setState(() => _selectedSkills.add(skill));
    }
  }

  void _removeSkill(Skill skill) {
    setState(() => _selectedSkills.removeWhere((s) => s.id == skill.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: '',
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressStepIndicator(totalSteps: 6, currentStep: 4),
            const SizedBox(height: 40),
            const Text(
              'Требуемые навыки',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: _isLoading ? null : _openSkillSearch,
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
                      color: Palette.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Search.svg',
                      width: 16,
                      height: 16,
                      color: Palette.navbar,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Поиск навыков',
                      style: TextStyle(
                        color: Palette.grey3,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
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
              children:
                  _selectedSkills.map((skill) {
                    return Chip(
                      label: Text(skill.name),
                      deleteIcon: SvgPicture.asset(
                        'assets/icons/Close.svg',
                        width: 15,
                        height: 15,
                        color: Palette.black,
                      ),
                      onDeleted: _isLoading ? null : () => _removeSkill(skill),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Palette.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Palette.white,
                    );
                  }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    _selectedSkills.isEmpty || _isLoading ? null : _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Palette.white),
                        )
                        : const Text(
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
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.grey3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Назад',
                  style: TextStyle(color: Palette.white, fontFamily: 'Inter'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
