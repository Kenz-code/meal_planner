import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {

  TextEditingController nameController = TextEditingController();

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  Future<void> save() async {
    var auth = FirebaseAuth.instance.currentUser;

    if (auth != null) {
      final data = {
        'first': nameController.text,
        'last': 'Ross'
      };

      FirebaseFirestore.instance.collection('Users').doc(auth.uid).update({
        'names': FieldValue.arrayUnion([data])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: nameController,
              ),
              ElevatedButton(onPressed: save, child: const Text("Save"))
            ],
          ),
        ),
      ),
    );
  }
}
