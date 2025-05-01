import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../util/palette.dart';
import '../../../util/routes.dart';


class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({Key? key}) : super(key: key);

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final _titleCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  List<String> _skills = [];
  String? _link;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _roleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickSkills() async {
    // TODO: открыть экран выбора навыков и получить результат
    final selected = await Navigator.pushNamed(context, Routes.searchSkills);
    if (selected is List<String>) {
      setState(() => _skills = selected);
    }
  }

  Future<void> _pickLink() async {
    final link = await Navigator.pushNamed(context, Routes.linkEntry);
    if (link is String) {
      setState(() => _link = link);
    }
  }

  void _save() {
    final dto = {
      'title': _titleCtrl.text.trim(),
      'role': _roleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'skills': _skills,
      'link': _link,
    };
    // TODO: отправить на бэкенд
    Navigator.of(context).pop(dto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление проекта'),
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
                _buildField('Описание проекта', 'Введите описание', _descCtrl, maxLines: 4),
                const SizedBox(height: 16),
                _buildChooser(
                  label: 'Навыки',
                  child: _skills.isEmpty
                      ? const Text('Выбрать навыки')
                      : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skills
                        .map((s) => Chip(label: Text(s)))
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

  Widget _buildField(String label, String hint, TextEditingController ctrl,
      {int maxLines = 1}) {
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                const Icon(Icons.chevron_right, color: Colors.black38),
              ],
            ),
          ),
        ),
      ],
    );
  }
}