import 'package:flutter/material.dart';
import 'package:meal/meal.dart';
import 'shared_pref_service.dart';

class MealApp extends InheritedWidget {
  final _MealAppWidgetState data;

  const MealApp({
    super.key,
    required Widget child,
    required this.data
  }) : super(child: child);

  static _MealAppWidgetState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<MealApp>()!.data;
    return result;
  }

  @override
  bool updateShouldNotify(MealApp old) {
    return this != old;
  }
}

class MealAppWidget extends StatefulWidget {
  final Widget child;

  const MealAppWidget({super.key, required this.child});

  @override
  State<MealAppWidget> createState() => _MealAppWidgetState();
}

class _MealAppWidgetState extends State<MealAppWidget> {
  bool? darkMode;
  late SharedPreferencesService _prefs;
  Future? fInit;

  @override
  initState() {
    super.initState();
    fInit = _loadSharedPreferences();
  }

  Future _loadSharedPreferences() async {
    _prefs = SharedPreferencesService();
    await _prefs.loadInstance();
    bool? isDark = _prefs.isDark();
    if (isDark != null) {
      darkMode = isDark ? true : false;
    } else {
      darkMode = false;
      _prefs.setIsDark(false);
    }
  }

  void changeTheme() {
    bool newMode;

    newMode = !_prefs.isDark()!;

    _prefs.setIsDark(newMode);

    setState(() {
      darkMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fInit,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MealApp(
            data: this,
            child: widget.child,
          );
        }
        return Container(
          key: Key('loading'),
        );
      },
    );
  }
}


