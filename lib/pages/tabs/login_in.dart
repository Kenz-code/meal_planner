import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_planner/auth/auth.dart';
import 'package:meal/meal.dart';

class LoginIn extends StatefulWidget {
  const LoginIn({super.key});

  @override
  State<LoginIn> createState() => _LoginInState();
}

class _LoginInState extends State<LoginIn> {

  late TextEditingController emailController = TextEditingController();
  late TextEditingController passController = TextEditingController();

  void navigate_to_meals() async {
    await FirebaseAuth.instance.currentUser != null;
    Future((){
      Navigator.of(context).pushReplacementNamed('/load_meals');
    });
  }

  void signInUser() async {
    try {
      await Auth.signInUser(emailAddress: emailController.text, pass: passController.text);
    } catch (e){
      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(MealSnackbar.configure(context, e.toString()));
      return;
    }
    navigate_to_meals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MealAppbar(
        label: "Sign In",
        darkMode: MealApp.of(context).darkMode!,
      ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MealTextField(
                  controller: emailController,
                  icon: Icons.email_rounded,
                  label: "Email",
                  inputType: TextInputType.emailAddress,
                ),
                MealTextField(
                  controller: passController,
                  icon: Icons.lock_rounded,
                  label: 'Password',
                  inputType: TextInputType.visiblePassword,
                ),
                MealDivider(height: 0),
                MealButton.primary(onPressed: signInUser, label: 'Log in'),
              ],
            ),
          ),
        )
    );
  }
}
