import "package:flutter/material.dart";
import 'package:meal/meal.dart';

class MealSegmentedButtonValue {
  final IconData? icon;
  final String label;
  MealSegmentedButtonValue({required this.label, this.icon});
}

class MealSegmentedButton extends StatefulWidget {
  final List<MealSegmentedButtonValue> values;
  final int initialPosition;
  final Function(int index) onSelected;

  const MealSegmentedButton({super.key, required this.values, required this.onSelected, this.initialPosition = 0});

  @override
  State<MealSegmentedButton> createState() => _MealSegmentedButtonState();
}

class _MealSegmentedButtonState extends State<MealSegmentedButton> {
  late int current;

  @override
  void initState() {
    super.initState();
    current = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 8,
      direction: Axis.horizontal,
      children: List.generate(
        widget.values.length,
        (index) => GestureDetector(
          onTap: () async {
            setState(() {
              current = index;
            });
            widget.onSelected(index);
          },
          child: SizedBox(
            width: 150,
            child: AnimatedContainer(
              curve: Curves.easeInOutCubic,
              duration: Duration(milliseconds: 150),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: Colors.transparent,
                border: Border.all(color: index == current ? darkMode! ? primary300 : primary600 : darkMode! ? neutral300 : neutral200, width: 2.0)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.values[index].icon != null ? [
                  Icon(widget.values[index].icon),
                  SizedBox(width: 4),
                  MealText.body(widget.values[index].label,color: darkMode! ? index == current ? neutral100 : neutral300 : neutral900,)
                ] : [MealText.body(widget.values[index].label, color: darkMode! ? index == current ? neutral100 : neutral300 : neutral900)],
              ),
            ),
          ),
        )
      ),
    );
  }
}

