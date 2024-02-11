import "package:flutter/material.dart";
import 'package:meal/meal.dart';

class MealButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  Color? color;
  Color? text_color;
  Color? outline_color;
  bool outline = false;
  bool underlined = false;
  bool primary = true;

  MealButton.primary({super.key, required this.onPressed, required this.label, this.icon}) : primary = true;
  MealButton.primary_outline({super.key, required this.onPressed, required this.label, this.icon}) : primary = true, outline = true;
  MealButton.primary_text({super.key, required this.onPressed, required this.label, this.icon}) : primary = true, underlined = true;
  MealButton.secondary({super.key, required this.onPressed, required this.label, this.icon}) : color = second600, text_color = neutral100;
  MealButton.secondary_outline({super.key, required this.onPressed, required this.label, this.icon}) : color = Colors.transparent, text_color = second600, outline = true, outline_color = second600;
  MealButton.secondary_text({super.key, required this.onPressed, required this.label, this.icon}) : color = Colors.transparent, text_color = second600, underlined = true;

  void setColors(context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    if (primary == true){
      if (outline == true) {
        color = Colors.transparent;
        text_color = darkMode! ? primary300 : primary600;
        outline_color = darkMode! ? primary300 : primary600;
      } else if (underlined == true) {
        color = Colors.transparent;
        text_color = darkMode! ? primary300 : primary600;
      } else {
        color = darkMode! ? primary300 : primary600;
        text_color = darkMode! ? neutral900 : neutral100;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setColors(context);
    return outline == false ? FilledButton(
      onPressed: onPressed,
      child: MealText.body(label, color: text_color, underlined: underlined,),
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(color!),
        padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(16)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: borderRadius
        )),
      ),
    ) : OutlinedButton(
          onPressed: onPressed,
          child: MealText.body(label, color: text_color),
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(color!),
            padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(16)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: borderRadius
            )),
            side: MaterialStateBorderSide.resolveWith((states) {
                if (states.contains(MaterialState.hovered)) {
                  return BorderSide(color: outline_color!, width: 3.0);
                }
                return BorderSide(color: outline_color!, width: 2.0);
              }
            )
          ),
    );
  }
}
