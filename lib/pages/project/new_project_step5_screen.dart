import 'package:flutter/material.dart';
import 'new_project_step6_screen.dart'; // 👈 подключение следующего шага

class NewProjectStep5Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const NewProjectStep5Screen({super.key, required this.previousData});

  @override
  State<NewProjectStep5Screen> createState() => _NewProjectStep5ScreenState();
}

class _NewProjectStep5ScreenState extends State<NewProjectStep5Screen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> selectedSkills = [];

  final List<String> allSkills = [
    'Создание логотипов',
    'UI/UX-дизайн',
    'Графический дизайн',
    'Иллюстрация',
    '3D-моделирование',
    'Анимация',
    'Motion Design',
    'Фирменный стиль',
    'Типографика',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get filteredSkills {
    final query = _searchController.text.toLowerCase();
    return allSkills
        .where((skill) =>
    skill.toLowerCase().contains(query) &&
        !selectedSkills.contains(skill))
        .toList();
  }

  void _addSkill(String skill) {
    setState(() {
      selectedSkills.add(skill);
      _searchController.clear();
    });
  }

  void _removeSkill(String skill) {
    setState(() => selectedSkills.remove(skill));
  }

  void _goToStep6() {
    final updatedData = {
      ...widget.previousData,
      'skills': selectedSkills,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewProjectStep6Screen(previousData: updatedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Новый проект'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressIndicator(),
            const SizedBox(height: 24),
            const Text(
              'Требуемые навыки',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSearchField(),
            const SizedBox(height: 16),
            if (filteredSkills.isNotEmpty)
              Wrap(
                spacing: 8,
                children: filteredSkills.map((skill) {
                  return ActionChip(
                    label: Text(
                      skill,
                      style: const TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                    shape: const StadiumBorder(
                      side: BorderSide(color: Colors.black),
                    ),
                    onPressed: () => _addSkill(skill),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            const Text(
              'Навыки',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedSkills.map((skill) {
                return Chip(
                  label: Text(skill),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _removeSkill(skill),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
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
                    onPressed: _goToStep6,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2842F7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Продолжить', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Назад', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Поиск',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 32,
          height: 6,
          decoration: BoxDecoration(
            color: index == 4 ? Color(0xFF2842F7) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
