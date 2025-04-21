import 'package:flutter/material.dart';
import 'new_project_step3_screen.dart';

class NewProjectStep2Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const NewProjectStep2Screen({super.key, required this.previousData});

  @override
  State<NewProjectStep2Screen> createState() => _NewProjectStep2ScreenState();
}

class _NewProjectStep2ScreenState extends State<NewProjectStep2Screen> {
  String? difficulty = 'Простой';

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
              'Уровень сложности',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildOption('Простой'),
            const SizedBox(height: 12),
            _buildOption('Средний'),
            const SizedBox(height: 12),
            _buildOption('Сложный'),
            const Spacer(),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final updatedData = {
                        ...widget.previousData,
                        'difficulty': difficulty,
                      };

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewProjectStep3Screen(
                            previousData: updatedData,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2842F7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Продолжить',
                      style: TextStyle(color: Colors.white),
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
                      backgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Назад',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String label) {
    final selected = difficulty == label;
    return InkWell(
      onTap: () => setState(() => difficulty = label),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF2842F7) : Colors.grey.shade300,
          ),
          color: selected ? const Color(0xFFE8F0FE) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? Color(0xFF2842F7) : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
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
            color: index == 1 ? Color(0xFF2842F7) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
