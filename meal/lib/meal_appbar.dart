import "package:flutter/material.dart";
import 'package:meal/meal.dart';

class MealAppbar extends AppBar{
  final String label;
  final bool darkMode;

  MealAppbar({required this.label, required this.darkMode}):super(
    title: MealText.title(label),
    backgroundColor: darkMode ? neutral800 : neutral100,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: darkMode ? neutral100 : neutral900)
  );
}
