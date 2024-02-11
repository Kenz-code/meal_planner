import "package:flutter/material.dart";
import 'package:meal/meal.dart';

class MealAutoComplete extends StatelessWidget {
  final TextEditingController controller;
  final List<String> options;
  final IconData? icon;
  final String label;

  final FocusNode _focusNode = FocusNode();

  MealAutoComplete({super.key, required this.controller, required this.options, this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return RawAutocomplete(
      textEditingController: controller,
      focusNode: _focusNode,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => Material(
        elevation: smallElevation,
        surfaceTintColor: Colors.transparent,
        shadowColor: darkMode! ? Colors.transparent : neutral200,
        borderRadius: borderRadius,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onFieldSubmitted,
          cursorColor: darkMode! ? primary300 : primary600,
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
        ),
      ),
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          borderRadius: borderRadius,
          child: Container(
            width: MediaQuery.of(context).size.width - 16,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) => ListTile(
                title: MealText.body(options.elementAt(index), color: darkMode! ? neutral300 : neutral900,),
                tileColor: darkMode! ? neutral700 : neutral200,
                onTap: () {onSelected(options.elementAt(index));},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
