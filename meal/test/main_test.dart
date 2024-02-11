import 'package:flutter/material.dart';
import 'package:meal/meal.dart';

void main() {

  runApp(MaterialApp(
    home: Scaffold(
      body: ListView(
        children: [
          MealCard(child: MealText.display("Test app"))
        ],
      )
    )
  ));

}