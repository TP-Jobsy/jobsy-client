import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../component/error_snackbar.dart';
import '../../../component/progress_step_indicator.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';
import 'new_project_step5_screen.dart';

class NewProjectStep4Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;
  final int draftId;

  const NewProjectStep4Screen({
    Key? key,
    required this.draftId,
    required this.previousData,
  }) : super(key: key);

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

  String _selectedLabel = 'Менее 1 месяца';
  bool _isSubmitting = false;

  Future<void> _onContinue() async {
    setState(() => _isSubmitting = true);

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message:'Пожалуйста, авторизуйтесь',
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final updated = {
      ...widget.previousData,
      'duration': _backendValues[_selectedLabel],
    };

    try {
      await ProjectService().updateDraft(
        widget.draftId,
        updated,
        token,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewProjectStep5Screen(
            draftId: widget.draftId,
            previousData: updated,
          ),
        ),
      );
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка сохранения срока',
        message:'$e',
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: '',
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressStepIndicator(totalSteps: 6, currentStep: 3),
            const SizedBox(height: 40),
            const Text(
              'Сроки выполнения',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 30),
            for (final label in _labels) ...[
              _buildRadioOption(label),
              const SizedBox(height: 12),
            ],
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
                  valueColor: AlwaysStoppedAnimation(Palette.white),
                )
                    : const Text(
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
                onPressed: _isSubmitting ? null : () => Navigator.pop(context),
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
      ),
    );
  }

  Widget _buildRadioOption(String label) {
    final selected = label == _selectedLabel;
    return InkWell(
      onTap: _isSubmitting ? null : () => setState(() => _selectedLabel = label),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Palette.primary : Palette.dotInactive,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              selected
                  ? 'assets/icons/RadioButton2.svg'
                  : 'assets/icons/RadioButton.svg',
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontFamily: 'Inter')),
          ],
        ),
      ),
    );
  }
}