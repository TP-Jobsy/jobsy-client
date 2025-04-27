import 'package:flutter/material.dart';
import '../../component/progress_step_indicator.dart';
import '../../util/pallete.dart';
import './new_project_step5_screen.dart';

class NewProjectStep4Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const NewProjectStep4Screen({Key? key, required this.previousData})
    : super(key: key);

  @override
  State<NewProjectStep4Screen> createState() => _NewProjectStep4ScreenState();
}

class _NewProjectStep4ScreenState extends State<NewProjectStep4Screen> {
  static const _labels = [
    'От 3 до 6 месяцев',
    'От 1 до 3 месяцев',
    'Менее 1 месяца',
  ];

  static const _backendValues = {
    'От 3 до 6 месяцев': 'LESS_THAN_6_MONTHS',
    'От 1 до 3 месяцев': 'LESS_THAN_3_MONTHS',
    'Менее 1 месяца': 'LESS_THAN_1_MONTH',
  };

  String selectedLabel = _labels.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            for (final label in _labels) ...[
              _buildRadioOption(label),
              const SizedBox(height: 12),
            ],
            const Spacer(),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final updated = {
                        ...widget.previousData,
                        'duration': _backendValues[selectedLabel],
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  NewProjectStep5Screen(previousData: updated),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String label) {
    final selected = label == selectedLabel;
    return InkWell(
      onTap: () => setState(() => selectedLabel = label),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Palette.primary : Palette.dotInactive,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? Palette.primary : Palette.grey3,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontFamily: 'Inter')),
          ],
        ),
      ),
    );
  }
}
