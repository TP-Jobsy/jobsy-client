import 'package:flutter/material.dart';

import '../util/palette.dart';

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
          width: 50,
          height: 6,
          decoration: BoxDecoration(
            color: index == currentStep ? Palette.primary : Palette.dotInactive,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
