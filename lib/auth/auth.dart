import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_planner/services/settings/settings_service.dart';

class Auth {

  static Future<void> createUser({emailAddress, pass}) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: pass,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        throw 'Invalid email.';
      }
      throw e.code;
    }
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null){
      FirebaseFirestore.instance.collection('meals').doc(auth.uid).set({
        'meals': []
      });
      await SettingsService.createDocument();
      FirebaseFirestore.instance.collection('grocery_list').doc(auth.uid).set({
        'grocery_list': []
      });
      FirebaseFirestore.instance.collection('ideas').doc(auth.uid).set({
        'ideas': []
      });
      FirebaseFirestore.instance.collection('persons').doc(auth.uid).set({
        'persons': []
      });
      FirebaseFirestore.instance.collection('groceries').doc(auth.uid).set({
        'groceries': []
      });
    }
  }

  static Future<void> signInUser({emailAddress, pass}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: pass
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        throw 'Invalid email or password.';
      }
      throw e.code;
    }
  }

  static Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

}