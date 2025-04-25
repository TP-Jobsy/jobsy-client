import 'package:flutter/material.dart';
import '../../component/progress_step_indicator.dart';
import '../../util/pallete.dart';
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
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Новый проект'),
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
            const ProgressStepIndicator(totalSteps: 6, currentStep: 3),
            const SizedBox(height: 24),
            const Text(
              'Сроки выполнения',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
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
                      backgroundColor: Palette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Продолжить',
                      style: TextStyle(color: Palette.white, fontFamily: 'Inter'),
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
                      style: TextStyle(color: Palette.white, fontFamily: 'Inter'),
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
            color: selected ? Palette.primary : Palette.dotInactive,
          ),
          color: Palette.white,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? Palette.primary : Palette.grey3,
            ),
            const SizedBox(width: 12),
            Text(value),
          ],
        ),
      ),
    );
  }

}
