import 'package:flutter/material.dart';
import 'package:meal/colors.dart';
import 'package:meal/meal.dart';

class MealFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final child;

  const MealFloatingButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return FloatingActionButton(
      onPressed: onPressed,
      child: child,
      backgroundColor: darkMode! ? primary300 : primary600,
      foregroundColor: darkMode! ? neutral900 : neutral100,
      elevation: bigElevation,
      shape: RoundedRectangleBorder(borderRadius: borderRadius)
    );
  }
}
