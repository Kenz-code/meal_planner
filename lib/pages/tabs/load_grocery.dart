import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_planner/services/settings/settings_service.dart';
import 'package:meal/meal.dart';

class LoadGroceryList extends StatefulWidget {
  const LoadGroceryList({super.key});

  @override
  State<LoadGroceryList> createState() => _LoadGroceryListState();
}

class _LoadGroceryListState extends State<LoadGroceryList> {

  var db;
  var data;
  var grocery_list;

  void loadMeals() async{
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      db = FirebaseFirestore.instance;
      final docRef = await db.collection('grocery_list').doc(auth.uid);
      await docRef.get().then((DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
      });
      if (data != null) {
        setState(() {
          grocery_list = data['grocery_list'];
        });
      }
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/grocery', (Route<dynamic> route) => false, arguments: {'grocery_list' : grocery_list});
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