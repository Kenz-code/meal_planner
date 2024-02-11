import 'package:flutter/material.dart';
import 'package:meal/meal.dart';

class MealText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? align;
  final Color? color;
  final bool underlined;
  final bool lessImportant;

  const MealText.heading(this.text, {this.align, this.color, this.underlined=false, this.lessImportant=false}) : style = headingStyle;
  const MealText.display(this.text, {this.align, this.color, this.underlined=false, this.lessImportant=false}) : style = displayStyle;
  const MealText.body(this.text, {this.align, this.color, this.underlined=false, this.lessImportant=false}) : style = bodyStyle;
  const MealText.label(this.text, {this.align, this.color, this.underlined=false, this.lessImportant=false}) : style = labelStyle;
  const MealText.title(this.text, {this.align, this.color, this.underlined=false, this.lessImportant=false}) : style = titleStyle;

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return Text(
      text,
      style: style.copyWith(color: color != null ? color : lessImportant ? darkMode! ? neutral300 : neutral700 : darkMode! ? neutral100 : neutral900, decoration: underlined == false? TextDecoration.none : TextDecoration.underline, decorationColor: color),
      textAlign: align,
    );
  }
}