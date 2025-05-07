import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../component/progress_step_indicator.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';
import 'new_project_step3_screen.dart';

const _complexityOptions = <_ComplexityOption>[
  _ComplexityOption(label: 'Простой', value: 'EASY'),
  _ComplexityOption(label: 'Средний', value: 'MEDIUM'),
  _ComplexityOption(label: 'Сложный', value: 'HARD'),
];

class NewProjectStep2Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;
  final int draftId;

  const NewProjectStep2Screen({
    Key? key,
    required this.draftId,
    required this.previousData,
  }) : super(key: key);

  @override
  State<NewProjectStep2Screen> createState() => _NewProjectStep2ScreenState();
}

class _NewProjectStep2ScreenState extends State<NewProjectStep2Screen> {
  final _projectService = ProjectService();
  String? _selectedValue = _complexityOptions.first.value;
  bool _isSubmitting = false;

  Future<void> _onContinue() async {
    if (_selectedValue == null) return;
    setState(() => _isSubmitting = true);

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      // неавторизованный пользователь
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, авторизуйтесь')),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final updated = {
      ...widget.previousData,
      'complexity': _selectedValue,
    };

    try {
      await _projectService.updateDraft(
        widget.draftId,
        updated,
        token,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewProjectStep3Screen(
            draftId: widget.draftId,
            previousData: updated,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения сложности: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
            ..._complexityOptions.map(_buildOption).toList(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )
                    : const Text(
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
                onPressed: _isSubmitting ? null : () => Navigator.pop(context),
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
          border: Border.all(color: selected ? Palette.primary : Palette.dotInactive),
          color: Palette.white,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              selected ? 'assets/icons/RadioButton2.svg' : 'assets/icons/RadioButton.svg',
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 12),
            Text(opt.label, style: const TextStyle(fontSize: 16, fontFamily: 'Inter')),
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