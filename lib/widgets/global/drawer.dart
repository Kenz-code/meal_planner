import 'package:flutter/material.dart';
import 'package:meal/meal.dart';

List<String> navigationRoutes = ['/load_meals', "/load_grocery", "/load_ideas", "/settings"];

class CustomDrawer extends StatefulWidget {
  final int index;
  const CustomDrawer({super.key, required this.index});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int screenIndex = 0;

  void handleScreenChanged(int selectedScreen) {
    Navigator.of(context).pushReplacementNamed(navigationRoutes[selectedScreen]);
  }

  @override
  void initState(){
    super.initState();
    screenIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return MealDrawer(
      onDestinationSelected: handleScreenChanged,
      selectedIndex: screenIndex,
        children: [
          MealDrawerItem(icon: Icons.fastfood_rounded, label: "Meals"),
          MealDrawerItem(icon: Icons.local_grocery_store_rounded, label: "Grocery list"),
          MealDrawerItem(icon: Icons.lightbulb_rounded, label: "Meal Ideas"),
          MealDrawerItem(icon: Icons.settings_rounded, label: "Settings"),
        ]
    );
  }
}

class CustomNavBar extends StatefulWidget {
  final int index;
  const CustomNavBar({super.key, required this.index});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int screenIndex = 0;

  void handleScreenChanged(int selectedScreen) {
    Navigator.of(context).pushReplacementNamed(navigationRoutes[selectedScreen]);
  }

  @override
  void initState(){
    super.initState();
    screenIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return MealNavBar(
        onDestinationSelected: handleScreenChanged,
        selectedIndex: screenIndex,
        children: [
          MealDrawerItem(icon: Icons.fastfood_rounded, label: "Meals"),
          MealDrawerItem(icon: Icons.local_grocery_store_rounded, label: "Grocery list"),
          MealDrawerItem(icon: Icons.lightbulb_rounded, label: "Meal Ideas"),
          MealDrawerItem(icon: Icons.settings_rounded, label: "Settings"),
        ]
    );
  }
}

