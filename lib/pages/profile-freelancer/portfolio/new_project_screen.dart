import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../model/skill.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';
import '../../project/skill_search/skill_search_screen.dart'; // <-- ваш экран поиска навыков

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({Key? key}) : super(key: key);

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final _titleCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final List<SkillDto> selectedSkills = [];

  // Теперь храним выбранные SkillDto
  List<SkillDto> _skills = [];
  String? _link;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _roleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickSkills() async {
    final skill = await Navigator.push<SkillDto>(
      context,
      MaterialPageRoute(builder: (_) => const SkillSearchScreen()),
    );
    if (skill != null) {
      setState(() {
        if (!_skills.any((s) => s.id == skill.id)) {
          _skills.add(skill);
        }
      });
    }
  }

  Future<void> _pickLink() async {
    final link = await Navigator.pushNamed(context, Routes.linkEntry);
    if (link is String) {
      setState(() => _link = link);
    }
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Название проекта обязательно')),
      );
      return;
    }

    // Собираем DTO для отправки
    final dto = <String, dynamic>{
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'link': _link ?? '',
      // Передаём по id или по названию — как вам нужно на сервере
      'skills': _skills.map((s) => s.id).toList(),
    };

    Navigator.of(context).pop(dto);
  }

  void _removeSkills(SkillDto skill) {
    setState(() {
      selectedSkills.removeWhere((s) => s.id == skill.id);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Добавление проекта'),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildField('Название проекта', 'Введите название', _titleCtrl),
                const SizedBox(height: 16),
                _buildField('Ваша роль', 'Введите роль', _roleCtrl),
                const SizedBox(height: 16),
                _buildField(
                  'Описание проекта',
                  'Введите описание',
                  _descCtrl,
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                _buildChooser(
                  label: 'Навыки',
                  child: _skills.isEmpty
                      ? const Text('Выбрать навыки')
                      : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skills
                        .map((s) => Chip(
                      label: Text(s.name),
                      backgroundColor: Palette.white,
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => _removeSkills(s),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Palette.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ))
                        .toList(),
                  ),
                  onTap: _pickSkills,
                ),
                const SizedBox(height: 16),
                _buildChooser(
                  label: 'Ссылка на проект',
                  child: Text(_link ?? 'Добавить'),
                  onTap: _pickLink,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(
                        color: Palette.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController ctrl, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Inter')),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildChooser({
    required String label,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Inter')),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Palette.grey3),
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(child: child),
                const Icon(Icons.chevron_right, color: Palette.black),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
