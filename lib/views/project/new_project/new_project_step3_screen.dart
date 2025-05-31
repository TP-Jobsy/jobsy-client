import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../component/error_snackbar.dart';
import '../../../component/progress_step_indicator.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';
import 'new_project_step4_screen.dart';

class NewProjectStep3Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;
  final int draftId;

  const NewProjectStep3Screen({
    Key? key,
    required this.draftId,
    required this.previousData,
  }) : super(key: key);

  @override
  State<NewProjectStep3Screen> createState() => _NewProjectStep3ScreenState();
}

class _NewProjectStep3ScreenState extends State<NewProjectStep3Screen> {
  late final ProjectService _projectService;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _projectService = context.read<ProjectService>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get commission => totalAmount * 0.1;

  double get freelancerAmount => totalAmount - commission;

  void _onAmountChanged(String value) {
    setState(() {
      totalAmount = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
    });
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final amount =
        double.tryParse(_controller.text.replaceAll(',', '.')) ?? 0.0;
    final updated = {...widget.previousData, 'fixedPrice': amount};

    try {
      await _projectService.updateDraft(widget.draftId, updated);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewProjectStep4Screen(
            draftId: widget.draftId,
            previousData: updated,
          ),
        ),
      );
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка сохранения суммы',
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 24,
            vertical: isVerySmallScreen ? 8 : 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProgressStepIndicator(totalSteps: 6, currentStep: 2),
                SizedBox(height: isVerySmallScreen ? 20 : 40),
                Text(
                  'Финансовая информация',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: isVerySmallScreen ? 20 : 30),
                _buildLabeledField(
                  label:
                  'Сумма, которую вы готовы заплатить за выполнение проекта',
                  controller: _controller,
                  hintText: '₽ 0.00',
                  onChanged: _onAmountChanged,
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isVerySmallScreen ? 25 : 40),
                _buildReadOnlyField(
                  label: 'Комиссия платформы (10%) — будет удержана с суммы',
                  value: '-₽ ${commission.toStringAsFixed(2)}',
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isVerySmallScreen ? 12 : 15),
                _buildReadOnlyField(
                  label: 'Сумма, которую фрилансер получит после комиссии',
                  value: '₽ ${freelancerAmount.toStringAsFixed(2)}',
                  isSmallScreen: isSmallScreen,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          isSmallScreen ? 16 : 24,
          0,
          isSmallScreen ? 16 : 24,
          isVerySmallScreen ? 12 : 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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

  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required void Function(String) onChanged,
    required bool isSmallScreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          decoration: InputDecoration(
            prefixText: '₽ ',
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.grey3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.grey3, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.red),
            ),
          ),
          validator: (val) {
            final amount = double.tryParse(val!.replaceAll(',', '.'));
            if (amount == null || amount <= 0) {
              return 'Введите корректную сумму';
            }
            return null;
          },
          onChanged: onChanged,
          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required bool isSmallScreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 25),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 14 : 16,
            vertical: isSmallScreen ? 12 : 14,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Palette.grey3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}