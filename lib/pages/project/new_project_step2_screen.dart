import 'package:flutter/material.dart';
import '../../component/progress_step_indicator.dart';
import '../../util/pallete.dart';
import 'new_project_step3_screen.dart';

const _complexityOptions = <_ComplexityOption>[
  _ComplexityOption(label: 'Простой', value: 'EASY'),
  _ComplexityOption(label: 'Средний', value: 'MEDIUM'),
  _ComplexityOption(label: 'Сложный', value: 'HARD'),
];

class NewProjectStep2Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const NewProjectStep2Screen({Key? key, required this.previousData})
      : super(key: key);

  @override
  State<NewProjectStep2Screen> createState() => _NewProjectStep2ScreenState();
}

class _NewProjectStep2ScreenState extends State<NewProjectStep2Screen> {
  String? _selectedValue = _complexityOptions.first.value;

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
            const ProgressStepIndicator(totalSteps: 6, currentStep: 1),
            const SizedBox(height: 24),
            const Text(
              'Уровень сложности',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            ..._complexityOptions.map((opt) => _buildOption(opt)),
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
                        'complexity': _selectedValue,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewProjectStep3Screen(
                            previousData: updated,
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
                      style: TextStyle(
                          color: Palette.white, fontFamily: 'Inter'),
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
                          color: Palette.white, fontFamily: 'Inter'),
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

  Widget _buildOption(_ComplexityOption opt) {
    final selected = _selectedValue == opt.value;
    return InkWell(
      onTap: () => setState(() => _selectedValue = opt.value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? Palette.primary : Palette.grey3,
            ),
            const SizedBox(width: 12),
            Text(
              opt.label,
              style: const TextStyle(fontSize: 16, fontFamily: 'Inter'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComplexityOption {
  final String label;
  final String value;
  const _ComplexityOption({required this.label, required this.value});
}
