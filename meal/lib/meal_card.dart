import 'package:flutter/material.dart';
import 'package:meal/meal.dart';

class MealCard extends StatelessWidget {
  final Widget? child;

  const MealCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius, side: darkMode! ? neutralBorderDark : neutralBorder),
      color: darkMode! ? neutral700 : neutral100,
      shadowColor: darkMode! ? Colors.transparent : neutral200,
      surfaceTintColor: Colors.transparent,
      elevation: smallElevation,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      )
    );
  }
}
