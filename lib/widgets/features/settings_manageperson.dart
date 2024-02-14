import 'package:flutter/material.dart';
import 'package:meal/meal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManagePerson extends StatefulWidget {
  const ManagePerson({super.key});

  @override
  State<ManagePerson> createState() => _ManagePersonState();
}

class _ManagePersonState extends State<ManagePerson> {
  List<String> persons = [];

  Future<String> loadPersons() async {
    final auth = FirebaseAuth.instance.currentUser!;
    var db = FirebaseFirestore.instance;
    var _data;
    final docRef = await db.collection('persons').doc(auth.uid);
    await docRef.get().then( (DocumentSnapshot doc) {
      _data = doc.data();
    } );
    persons = _data['persons'].cast<String>();
    return "Done";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MealAppbar(
        darkMode: MealApp.of(context).darkMode!,
        label: "Manage Default People",
      ),
      body: FutureBuilder(
        future: loadPersons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return PersonTile(person: persons[index], onDelete: () {setState(() {});},);
              },
              itemCount: persons.length,
            );
          } else {
            return MealLoading();
          }
        },
      )
    );
  }
}

class PersonTile extends StatelessWidget {
  final String person;
  final Function? onDelete;

  const PersonTile({super.key, required this.person, this.onDelete});

  void deletePerson() {
    final auth = FirebaseAuth.instance.currentUser!;

    FirebaseFirestore.instance.collection('persons').doc(auth.uid).update({
      'persons': FieldValue.arrayRemove([person])
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: MealText.body(person),
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

