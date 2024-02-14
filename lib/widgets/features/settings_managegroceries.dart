import 'package:flutter/material.dart';
import 'package:meal/meal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageGroceries extends StatefulWidget {
  const ManageGroceries({super.key});

  @override
  State<ManageGroceries> createState() => _ManageGroceriesState();
}

class _ManageGroceriesState extends State<ManageGroceries> {
  List<String> groceries = [];

  Future<String> loadGroceries() async {
    final auth = FirebaseAuth.instance.currentUser!;
    var db = FirebaseFirestore.instance;
    var _data;
    final docRef = await db.collection('groceries').doc(auth.uid);
    await docRef.get().then( (DocumentSnapshot doc) {
      _data = doc.data();
    } );
    groceries = _data['groceries'].cast<String>();
    return "Done";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MealAppbar(
        darkMode: MealApp.of(context).darkMode!,
        label: "Manage Default Groceries",
      ),
      body: FutureBuilder(
        future: loadGroceries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return GroceryTile(grocery: groceries[index], onDelete: () {setState(() {});},);
              },
              itemCount: groceries.length,
            );
          } else {
            return MealLoading();
          }
        },
      )
    );
  }
}

class GroceryTile extends StatelessWidget {
  final String grocery;
  final Function? onDelete;

  const GroceryTile({super.key, required this.grocery, this.onDelete});

  void deletePerson() {
    final auth = FirebaseAuth.instance.currentUser!;

    FirebaseFirestore.instance.collection('groceries').doc(auth.uid).update({
      'groceries': FieldValue.arrayRemove([grocery])
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: MealText.body(grocery),
      trailing: MealButton.primary_icon(
        onPressed: () {
          deletePerson();
          onDelete!();
        },
        icon: Icons.delete_rounded
      ),
    );
  }
}

