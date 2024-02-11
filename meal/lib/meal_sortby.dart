import 'package:flutter/material.dart';
import 'package:meal/meal.dart';



class MealSortBy extends StatefulWidget {
  final List<String> chips;
  Function(int index)? onSelected;

  MealSortBy({super.key, required this.chips, this.onSelected});

  @override
  State<MealSortBy> createState() => _MealSortByState();
}

class _MealSortByState extends State<MealSortBy> {
  int? _value = 0;

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          MealText.body("Sort by:"),
          SizedBox(width: 8,),
          Wrap(
            direction: Axis.horizontal,
            spacing: 8,
            children: List<Widget>.generate(
              widget.chips.length,
              (index) => ChoiceChip(
                label: MealText.body(widget.chips[index], color: _value == index ? darkMode! ? neutral900 : neutral100 : darkMode! ? primary300 : primary600),
                selected: _value == index,
                onSelected: (bool selected) {
                  selected == true ? widget.onSelected!(index) : null;
                  setState(() {
                    _value = selected ? index : index;
                  });
                },
                color: MaterialStateColor.resolveWith((states) {
                  if (states.contains(MaterialState.selected)){
                    return darkMode! ? primary300 : primary600;
                  }
                  return darkMode! ? neutral800 : neutral100;
                }),
                checkmarkColor: darkMode! ? neutral900 : neutral100,
                side: _value == index ? BorderSide(style: BorderStyle.none) : darkMode! ? primaryBorderDark : primaryBorder,
              )
            ).toList()
          ),
        ],
      ),
    );
  }
}
