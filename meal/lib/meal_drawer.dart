import 'package:flutter/material.dart';
import 'package:meal/meal.dart';

class MealDrawerItem {
  final String label;
  final IconData icon;

  MealDrawerItem({required this.icon, required this.label});
}

class MealDrawer extends StatelessWidget {
  final Function(int index) onDestinationSelected;
  final int selectedIndex;
  final List<MealDrawerItem> children;

  const MealDrawer({super.key, required this.onDestinationSelected, required this.selectedIndex, required this.children});

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: NavigationDrawer(
        backgroundColor: darkMode! ? neutral800 : neutral100,
        indicatorColor: darkMode! ? primary300 : primary600,
        indicatorShape: RoundedRectangleBorder(borderRadius: borderRadius),
        onDestinationSelected: onDestinationSelected,
        selectedIndex: selectedIndex,
        children: List.generate(
          children.length,
          (index) => NavigationDrawerDestination(icon: Icon(children[index].icon, color: selectedIndex == index ?
          darkMode! ? neutral900 : neutral100 :
          darkMode! ? neutral300 : neutral900,), label: MealText.body(children[index].label, color: selectedIndex == index ?
          darkMode! ? neutral900 : neutral100 :
          darkMode! ? neutral300 : neutral900,))
        )
      ),
    );
  }
}
