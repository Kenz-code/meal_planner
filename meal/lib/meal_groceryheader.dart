import 'package:flutter/material.dart';
import 'package:meal/meal.dart';

class MealGroceryHeader extends StatelessWidget {
  final String title;

  const MealGroceryHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return Card(
      color: darkMode! ? primary300 : primary600,
      shape: RoundedRectangleBorder(),
      elevation: smallElevation,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: MealText.body(title, color: darkMode! ? neutral900 : neutral100),
      ),
    );
  }
}
