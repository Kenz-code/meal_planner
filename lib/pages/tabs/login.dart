import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meal_planner/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal/meal.dart';
import 'package:meal_planner/utils/images.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 32),
                  child: imgLogo,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: MealText.display("Meal Planner"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MealButton.primary(onPressed: () {Navigator.pushNamed(context, '/login_in');}, label: 'Sign in'),
                      SizedBox(height: 16,),
                      MealButton.primary_outline(onPressed: () {Navigator.pushNamed(context, '/login_up');}, label: 'Register Free'),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}