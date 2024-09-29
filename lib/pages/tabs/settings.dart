import 'package:flutter/material.dart';
import 'package:meal_planner/widgets/global/drawer.dart';
import 'package:meal_planner/auth/auth.dart';
import 'package:meal_planner/services/settings/settings_service.dart';
import 'package:meal/meal.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:meal_planner/widgets/features/settings_manageperson.dart';
import 'package:meal_planner/widgets/features/settings_managegroceries.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  late AppSettings settings = AppSettings(deletePastMeals: true);

  void sign_out() {
    Auth.signOutUser();
    Navigator.of(context).pushReplacementNamed('/load_login');
  }

  @override
  void initState() {
    super.initState();
    loadSettings().then((value) => setState((){}));
  }

  Future<void> loadSettings() async {
    settings = await SettingsService.loadSettings();
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(index: 3),
      appBar: MealAppbar(
        label: 'Settings',
        darkMode: MealApp.of(context).darkMode!,
      ),
      body: ListView(
        children: [
          ListTile(
            title: MealText.body("Dark mode"),
            leading: Icon(Icons.light_mode_rounded, color: MealApp.of(context).darkMode! ? neutral100 : neutral900,),
            trailing: MealToggleSwitch(
                value: MealApp.of(context).darkMode!,
                onChanged: (bool value) async{ MealApp.of(context).changeTheme(); }
            ),
          ),
          ListTile(
            title: MealText.body("Delete past meals"),
            leading: Icon(Icons.delete_rounded, color: MealApp.of(context).darkMode! ? neutral100 : neutral900,),
            trailing: MealToggleSwitch(
              value: settings.deletePastMeals,
              onChanged: (bool value) async{ SettingsService.saveSetting('deletePastMeals', value); await loadSettings();setState((){});}
            ),
          ),
          ListTile(
            title: MealText.body("Manage default people"),
            leading: Icon(Icons.people_rounded, color: MealApp.of(context).darkMode! ? neutral100 : neutral900,),
            trailing: Icon(Icons.arrow_forward_rounded, color: MealApp.of(context).darkMode! ? neutral100 : neutral900,),
            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePerson()));},
          ),
          ListTile(
            title: MealText.body("Manage default groceries"),
            leading: Icon(Icons.shopping_cart_rounded, color: MealApp.of(context).darkMode! ? neutral100 : neutral900,),
            trailing: Icon(Icons.arrow_forward_rounded, color: MealApp.of(context).darkMode! ? neutral100 : neutral900,),
            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ManageGroceries()));},
          ),
          ListTile(
            title: MealText.body("Sign out"),
            leading: Icon(Icons.logout_rounded, color: MealApp.of(context).darkMode! ? neutral100 : neutral900,),
            onTap: sign_out,
          ),
          ListTile(
            title: MealText.body("Delete account", color: MealApp.of(context).darkMode! ? error300 : error600),
            leading: Icon(Icons.delete_forever_rounded, color: MealApp.of(context).darkMode! ? error300 : error600,),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => DeleteUserPopup()
            ),
          ),
          FutureBuilder(
            future: getAppVersion(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                    title: MealText.label("Version number: ${snapshot.data}", lessImportant: true,)
                );
              }
              else {
                return ListTile(
                    title: MealText.label("Version number: Loading...", lessImportant: true,)
                );
              }
            }
          )
        ],
      ),
    );
  }
}

class DeleteUserPopup extends StatelessWidget {
  const DeleteUserPopup({super.key});

  void delete_user(context) {
    Auth.deleteUser();
    Navigator.of(context).pushReplacementNamed('/load_login');
  }

  @override
  Widget build(BuildContext context) {
    return MealAlertDialog(
      title: "Delete account",
      content: "This will delete all your data.",
      actions: [
        MealButton.primary_outline(onPressed: () { Navigator.of(context).pop(); }, label: "Cancel"),
        MealButton.primary(onPressed: () { delete_user(context); }, label: "Delete"),
      ],
    );
  }
}

