import 'package:flutter/material.dart';
import 'package:meal/meal.dart';

class MealDialog extends StatelessWidget {
  final Widget child;

  const MealDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      backgroundColor: darkMode! ? neutral800 : neutral100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
