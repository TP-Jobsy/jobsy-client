import 'package:flutter/material.dart';

class ProgressStepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const ProgressStepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 32,
          height: 6,
          decoration: BoxDecoration(
            color: index == currentStep ? const Color(0xFF2842F7) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
