import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meal_planner/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestLogin extends StatefulWidget {
  const TestLogin({super.key});

  @override
  State<TestLogin> createState() => _TestLoginState();
}

class _TestLoginState extends State<TestLogin> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passController = TextEditingController();

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser != null) {
      Future((){
        Navigator.of(context).pushReplacementNamed('/data');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: emailController,
            ),
            TextField(
              controller: passController,
            ),
            ElevatedButton(onPressed: () {
              Auth.createUser(emailAddress: emailController.text, pass: passController.text);
            }, child: Text('Register')),
            ElevatedButton(onPressed: () {
              Auth.signInUser(emailAddress: emailController.text, pass: passController.text);
            }, child: Text('Log in')),
          ],
        ),
      )
    );
  }
}
