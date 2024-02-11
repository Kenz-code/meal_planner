import "package:flutter/material.dart";
import 'package:meal/meal.dart';

class MealTextField extends StatelessWidget {
  final TextEditingController controller;
  IconData? icon;
  final String? label;
  final VoidCallback? onTap;
  final bool readOnly;
  bool multiline = false;
  int maxLines = 1;
  TextInputType inputType = TextInputType.text;

  MealTextField({super.key, required this.controller, this.icon, this.label, this.onTap, this.readOnly=false, this.inputType=TextInputType.text});
  MealTextField.multiline({super.key, required this.controller, this.icon, this.label, this.onTap, this.readOnly=false, this.maxLines=1}) : multiline = true;

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return Material(
      elevation: smallElevation,
      surfaceTintColor: Colors.transparent,
      shadowColor: darkMode! ? Colors.transparent : neutral200,
      borderRadius: borderRadius,
      child: TextField(
        keyboardType: multiline ? TextInputType.multiline : inputType,
        minLines: 1,
        maxLines: maxLines,
        controller: controller,
        cursorColor: darkMode! ? primary300 : primary600,
        textAlignVertical: TextAlignVertical.center,
        style: bodyStyle.copyWith(color: darkMode! ? neutral100 : neutral900),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 14),
          prefixIconColor: darkMode! ? neutral300 : neutral700,
          hintText: label,
          hintStyle: bodyStyle.copyWith(color: darkMode! ? neutral300 : neutral700),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: darkMode! ? neutralBorderDark : neutralBorder
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: darkMode! ? primaryBorderDark : primaryBorder
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: darkMode! ? neutralBorderDark : neutralBorder
          ),
          filled: true,
          fillColor: darkMode! ? neutral700 : neutral100,
          contentPadding: EdgeInsets.all(16),
        ),
        onTap: onTap,
        readOnly: readOnly,
      ),
    );
  }
}
