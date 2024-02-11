import "package:flutter/material.dart";
import 'package:meal/meal.dart';

class MealSnackbar extends SnackBar {
  MealSnackbar({
    Key? key,
    required String label,
    Widget? content,
    Color? backgroundColor
  }) : super(
      key: key,
      content: content == null ? MealText.body(label, color: neutral100,) : content,
      backgroundColor: backgroundColor == null ? error600 : backgroundColor,
  );

  static MealSnackbar configure(context, label) {
    return MealSnackbar(label: label, backgroundColor: MealApp.of(context).darkMode! ? error300 : error600, content: MealText.body(label, color: MealApp.of(context).darkMode! ? neutral900 : neutral100,));
  }
}
