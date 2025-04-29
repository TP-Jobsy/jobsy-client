import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../component/progress_step_indicator.dart';
import '../../../util/pallete.dart';
import 'new_project_step4_screen.dart';

class NewProjectStep3Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const NewProjectStep3Screen({super.key, required this.previousData});

  @override
  State<NewProjectStep3Screen> createState() => _NewProjectStep3ScreenState();
}

class _NewProjectStep3ScreenState extends State<NewProjectStep3Screen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  double totalAmount = 0.0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get commission => totalAmount * 0.1;
  double get freelancerAmount => totalAmount - commission;

  void _onAmountChanged(String value) {
    setState(() {
      totalAmount = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
    });
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressStepIndicator(totalSteps: 6, currentStep: 2),
              const SizedBox(height: 24),
              const Text(
                'Финансовая информация',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 16),
              _buildLabeledField(
                label: 'Сумма, которую вы готовы заплатить за выполнение проекта',
                controller: _amountController,
                hintText: '₽ 0.00',
                onChanged: _onAmountChanged,
              ),
              const SizedBox(height: 16),
              _buildReadOnlyField(
                label: 'Комиссия платформы (10%) — будет удержана с суммы',
                value: '-₽ ${commission.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 16),
              _buildReadOnlyField(
                label: 'Сумма, которую фрилансер получит после комиссии',
                value: '₽ ${freelancerAmount.toStringAsFixed(2)}',
              ),
              const Spacer(),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final updatedData = {
                            ...widget.previousData,
                            'fixedPrice': totalAmount,
                          };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewProjectStep4Screen(
                                previousData: updatedData,
                              ),
                            ),
                          );
                        }
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
              )
            ],
          ),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (val) {
            final amount = double.tryParse(val!.replaceAll(',', '.'));
            if (amount == null || amount <= 0) return 'Введите корректную сумму';
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
