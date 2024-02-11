import "package:flutter/material.dart";
import 'package:meal/meal.dart';

class MealRefresh extends StatelessWidget {
  final child;
  final onRefresh;

  const MealRefresh({super.key, required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return RefreshIndicator(
      child: child,
      onRefresh: onRefresh,
      backgroundColor: darkMode! ? neutral700 : neutral100,
      color: darkMode! ? primary300 : primary600,
    );
  }
}
