import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_planner/services/settings/settings_service.dart';
import 'package:meal/meal.dart';

class LoadIdeas extends StatefulWidget {
  const LoadIdeas({super.key});

  @override
  State<LoadIdeas> createState() => _LoadIdeasState();
}

class _LoadIdeasState extends State<LoadIdeas> {

  var db;
  var data;
  var ideas;

  void loadIdeas() async{
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      db = FirebaseFirestore.instance;
      final docRef = await db.collection('ideas').doc(auth.uid);
      await docRef.get().then((DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
      });
      if (data != null) {
        setState(() {
          ideas = data['ideas'];
        });
      }
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/ideas', (Route<dynamic> route) => false, arguments: {'ideas' : ideas});
  }

  @override
  void initState(){
    super.initState();
    loadIdeas();
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