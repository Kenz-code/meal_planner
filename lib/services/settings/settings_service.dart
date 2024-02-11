import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum brightnessModes { system, light, dark }

class AppSettings {
  // update
  bool deletePastMeals;

  AppSettings({required this.deletePastMeals});
}

class SettingsService {

  static Future<AppSettings> loadSettings() async {
    var data;
    if (FirebaseAuth.instance.currentUser != null) {
      final auth = FirebaseAuth.instance.currentUser;
      if (auth != null) {
        var db = FirebaseFirestore.instance;
        final docRef = await db.collection('settings').doc(auth.uid);
        await docRef.get().then((DocumentSnapshot doc) {
          data = doc.data() as Map<String, dynamic>;
        });
      }
    }
    // update
    bool deletePastMeals = data['deletePastMeals'];


    // update for shared prefs
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    return AppSettings(deletePastMeals: deletePastMeals);
  }

  static void saveSetting(String setting, var value) {
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      FirebaseFirestore.instance.collection("settings").doc(auth.uid).update(
          {setting: value});
    }
  }

  static void saveSettingPrefs(String setting, var value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(setting, value);
  }

  static Future<void> createDocument() async {
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      await FirebaseFirestore.instance.collection("settings").doc(auth.uid).set({
        // update
        'deletePastMeals' : true,
      });
    }
  }
}