import 'package:flutter/material.dart';
import 'package:meal/meal.dart';

class MealAlertDialog extends StatelessWidget {
  final List<Widget> actions;
  final String title;
  final String content;

  const MealAlertDialog({super.key, required this.actions, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      backgroundColor: darkMode! ? neutral800 : neutral100,
      actions: actions,
      title: MealText.heading(title),
      content: MealText.body(content),
    );
  }
}