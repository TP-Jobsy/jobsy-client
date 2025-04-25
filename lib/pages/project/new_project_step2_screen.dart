import 'package:flutter/material.dart';
import '../../component/progress_step_indicator.dart';
import '../../util/pallete.dart';
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
            const ProgressStepIndicator(totalSteps: 6, currentStep: 1),
            const SizedBox(height: 24),
            const Text(
              'Уровень сложности',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),
            _buildOption('Простой'),
            const SizedBox(height: 16),
            _buildOption('Средний'),
            const SizedBox(height: 16),
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
            color: selected ? Palette.primary : Palette.dotInactive,
          ),
          color:  Palette.white,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? Palette.primary : Palette.grey3,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16, fontFamily: 'Inter')),
          ],
        ),
      ),
    );
  }
}
