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
    final screenWidth = MediaQuery.of(context).size.width;

    double availableWidth = screenWidth * 0.8;
    double stepSpacing = 4;
    double stepWidth = (availableWidth - ((totalSteps - 1) * stepSpacing)) / totalSteps;
    stepWidth = stepWidth.clamp(24.0, 60.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: stepSpacing / 2),
          width: stepWidth,
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

