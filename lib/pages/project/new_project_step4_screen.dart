import 'package:flutter/material.dart';
import './new_project_step5_screen.dart';

class NewProjectStep4Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const NewProjectStep4Screen({super.key, required this.previousData});

  @override
  State<NewProjectStep4Screen> createState() => _NewProjectStep4ScreenState();
}

class _NewProjectStep4ScreenState extends State<NewProjectStep4Screen> {
  String selectedDeadline = 'Менее 1 месяца';

  final deadlines = [
    'От 3 до 6 месяцев',
    'От 1 до 3 месяцев',
    'Менее 1 месяца',
  ];

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
              'Сроки выполнения',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...deadlines.map((option) => _buildRadioOption(option)),
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
                        'deadline': selectedDeadline,
                      };

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewProjectStep5Screen(
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

  Widget _buildRadioOption(String value) {
    final selected = value == selectedDeadline;

    return InkWell(
      onTap: () => setState(() => selectedDeadline = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Color(0xFF2842F7) : Colors.grey.shade300,
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
            Text(value),
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
            color: index == 3 ? Color(0xFF2842F7) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
