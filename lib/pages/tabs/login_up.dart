import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_planner/auth/auth.dart';
import 'package:meal/meal.dart';

class LoginUp extends StatefulWidget {
  const LoginUp({super.key});

  @override
  State<LoginUp> createState() => _LoginUpState();
}

class _LoginUpState extends State<LoginUp> {

  late TextEditingController emailController = TextEditingController();
  late TextEditingController passController = TextEditingController();

  void navigate_to_meals() async {
    await FirebaseAuth.instance.currentUser != null;
    Future((){
      Navigator.of(context).pushReplacementNamed('/load_meals');
    });
  }

  void createUser() async {
    try {
      await Auth.createUser(emailAddress: emailController.text, pass: passController.text);
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
          label: "Register",
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
                MealButton.primary(onPressed: createUser, label: 'Create Account'),
              ],
            ),
          ),
        )
    );
  }
}
