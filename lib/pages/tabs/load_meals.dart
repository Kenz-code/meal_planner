import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_planner/services/settings/settings_service.dart';
import 'package:meal/meal.dart';

class LoadMeals extends StatefulWidget {
  const LoadMeals({super.key});

  @override
  State<LoadMeals> createState() => _LoadMealsState();
}

class _LoadMealsState extends State<LoadMeals> {

  var db;
  var data;
  var meals;

  void loadMeals() async{
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      db = FirebaseFirestore.instance;
      final docRef = await db.collection('meals').doc(auth.uid);
      await docRef.get().then((DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
      });
      if (data != null) {
        setState(() {
          meals = data['meals'];
        });
      }
    }

    //delete past meals
    var settings = await SettingsService.loadSettings();
    if (settings.deletePastMeals == true) {
      for (var meal in meals) {
        var date = meal['date'].toDate();
        var now = DateTime.now();
        if (now.isAfter(date)) {
          if (auth != null) {
            db = FirebaseFirestore.instance;
            await db.collection("meals").doc(auth.uid).update({
              'meals': FieldValue.arrayRemove([meal])
            });
          };
        }
      }
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/meals', (Route<dynamic> route) => false, arguments: {'meals' : meals});
  }

  @override
  void initState(){
    super.initState();
    loadMeals();
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