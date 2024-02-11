import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal/meal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadLogin extends StatefulWidget {
  const LoadLogin({super.key});

  @override
  State<LoadLogin> createState() => _LoadLoginState();
}

class _LoadLoginState extends State<LoadLogin> {

  Future<void> checkAuth() async {
    //check for first time
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    if (firstTime != null && !firstTime) {// Not first time
      if (FirebaseAuth.instance.currentUser != null) {
        Future((){Navigator.of(context).pushReplacementNamed('/load_meals');});
      } else {
        Future((){Navigator.of(context).pushReplacementNamed('/login');});
      }
    } else {// First time
      prefs.setBool('first_time', false);
      Future((){Navigator.of(context).pushReplacementNamed('/onboarding');});
    }
  }

  @override
  void initState() {
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitThreeBounce(color: primary600)
      ),
    );
  }
}
