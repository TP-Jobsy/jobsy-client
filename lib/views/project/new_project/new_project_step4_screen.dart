import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../component/error_snackbar.dart';
import '../../../component/progress_step_indicator.dart';
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
  late final ProjectService _projectService;
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

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('NewProjectStep4_opened');
    _projectService = context.read<ProjectService>();
  }

  Future<void> _onContinue() async {
    setState(() => _isSubmitting = true);

    final updated = {
      ...widget.previousData,
      'duration': _backendValues[_selectedLabel],
    };

    try {
      AppMetrica.reportEvent('NewProjectStep4_completed');
      await _projectService.updateDraft(widget.draftId, updated);
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
        message: '$e',
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenHeight < 600;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: '',
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: isSmallScreen ? 16 : 20,
            height: isSmallScreen ? 16 : 20,
            color: Palette.navbar,
          ),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 24,
          vertical: isVerySmallScreen ? 8 : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressStepIndicator(totalSteps: 6, currentStep: 3),
            SizedBox(height: isVerySmallScreen ? 20 : 40),
            Text(
              'Сроки выполнения',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: isVerySmallScreen ? 20 : 30),
            for (final label in _labels) ...[
              _buildRadioOption(label, isSmallScreen),
              SizedBox(height: isVerySmallScreen ? 8 : 12),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: isSmallScreen ? 45 : 50,
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
                    : Text(
                  'Продолжить',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Palette.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            SizedBox(
              width: double.infinity,
              height: isSmallScreen ? 45 : 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.grey3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Назад',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
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

  Widget _buildRadioOption(String label, bool isSmallScreen) {
    final selected = label == _selectedLabel;
    return InkWell(
      onTap: _isSubmitting ? null : () => setState(() => _selectedLabel = label),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 12 : 14,
          horizontal: isSmallScreen ? 14 : 16,
        ),
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
              width: isSmallScreen ? 14 : 16,
              height: isSmallScreen ? 14 : 16,
            ),
            SizedBox(width: isSmallScreen ? 10 : 12),
            Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}