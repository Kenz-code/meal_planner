import 'package:flutter/material.dart';
import 'package:meal/meal.dart';

class MealDivider extends StatelessWidget {
  final double height;

  const MealDivider({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return Divider(
      color: darkMode! ? neutral700 : neutral200,
      thickness: 2.0,
      height: height,
    );
  }
}
