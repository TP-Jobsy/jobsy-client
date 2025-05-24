import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../component/error_snackbar.dart';
import '../../../component/progress_step_indicator.dart';
import '../../../provider/auth_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  double totalAmount = 0.0;

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

    final amount = double.tryParse(_controller.text.replaceAll(',', '.')) ?? 0.0;
    final updated = {
      ...widget.previousData,
      'fixedPrice': amount,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProgressStepIndicator(totalSteps: 6, currentStep: 2),
                const SizedBox(height: 40),
                const Text(
                  'Финансовая информация',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 30),
                _buildLabeledField(
                  label: 'Сумма, которую вы готовы заплатить за выполнение проекта',
                  controller: _controller,
                  hintText: '₽ 0.00',
                  onChanged: _onAmountChanged,
                ),
                const SizedBox(height: 40),
                _buildReadOnlyField(
                  label: 'Комиссия платформы (10%) — будет удержана с суммы',
                  value: '-₽ ${commission.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 15),
                _buildReadOnlyField(
                  label: 'Сумма, которую фрилансер получит после комиссии',
                  value: '₽ ${freelancerAmount.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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


  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontFamily: 'Inter')),
        const SizedBox(height: 8),
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
                borderSide: const BorderSide(color: Palette.grey3),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Palette.grey3, width: 1.5),
              ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Palette.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Palette.red),
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
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontFamily: 'Inter')),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 25),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Palette.grey3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontFamily: 'Inter'),
          ),
        ),
      ],
    );
  }
}