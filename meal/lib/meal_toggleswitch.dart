import 'package:flutter/material.dart';
import 'package:meal/meal.dart';

class MealToggleSwitch extends StatefulWidget {
  final Function(bool) onChanged;
  bool value;

  MealToggleSwitch({super.key, required this.onChanged, required this.value});

  @override
  State<MealToggleSwitch> createState() => _MealToggleSwitchState();
}

class _MealToggleSwitchState extends State<MealToggleSwitch> {
  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return GestureDetector(
      onTap: () {
        widget.value = !widget.value;
        widget.onChanged(widget.value);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        width: 64,
        height: 32,
        decoration: BoxDecoration(
            borderRadius: borderRadius,
          color: widget.value ? darkMode! ? primary300 : primary600 : darkMode! ? neutral700 : neutral200
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 300),
          alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.decelerate,
          child: Padding(
            padding: EdgeInsets. all(3),
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: neutral100
              ),
            ),
          ),
        ),
      ),
    );
  }
}
