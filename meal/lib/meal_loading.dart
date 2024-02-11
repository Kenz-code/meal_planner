import "package:flutter/material.dart";
import 'package:meal/meal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MealLoading extends StatelessWidget {
  const MealLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return SpinKitThreeBounce(color: darkMode! ? primary300 : primary600);
  }
}
