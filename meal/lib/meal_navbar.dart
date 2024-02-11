import 'package:meal/meal.dart';
import 'package:flutter/material.dart';

class MealNavBar extends StatelessWidget {
  final Function(int index) onDestinationSelected;
  final int selectedIndex;
  final List<MealDrawerItem> children;

  const MealNavBar({super.key, required this.onDestinationSelected, required this.selectedIndex, required this.children});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: neutral100,
      elevation: smallElevation,
      surfaceTintColor: Colors.transparent,
      shadowColor: neutral200,
      onDestinationSelected: onDestinationSelected,
      indicatorShape: RoundedRectangleBorder(borderRadius: borderRadius),
      selectedIndex: selectedIndex,
      destinations: List.generate(
          children.length,
              (index) => NavigationDestination(icon: Icon(children[index].icon, color: selectedIndex == index ? neutral100 : neutral900,), label: children[index].label)
      ),
    );
  }
}
