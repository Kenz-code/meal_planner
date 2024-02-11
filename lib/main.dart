import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal/colors.dart';
import 'firebase_options.dart';
import 'package:meal_planner/utils/theme.dart';
import 'package:meal_planner/pages/tabs/meals.dart';
import 'package:meal_planner/pages/tabs/login.dart';
import 'package:meal_planner/auth/auth.dart';
import 'package:meal_planner/pages/tabs/new_meal.dart';
import 'package:meal_planner/pages/tabs/load_login.dart';
import 'package:meal_planner/pages/tabs/load_meals.dart';
import 'package:meal_planner/pages/tabs/settings.dart';
import 'package:meal_planner/pages/tabs/load_grocery.dart';
import 'package:meal_planner/pages/tabs/grocery.dart';
import 'package:meal_planner/pages/tabs/new_grocery.dart';
import 'package:meal_planner/pages/tabs/ideas.dart';
import 'package:meal_planner/pages/tabs/load_ideas.dart';
import 'package:meal_planner/pages/tabs/new_idea.dart';
import 'package:meal_planner/pages/tabs/login_in.dart';
import 'package:meal_planner/pages/tabs/login_up.dart';
import 'package:meal_planner/services/settings/settings_service.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:meal_planner/pages/tabs/onboarding.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:meal/meal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MealAppWidget(child: MyApp()));
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final bool? darkMode = MealApp.of(context).darkMode;
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: darkMode! ? neutral800 : neutral100
      ),
      initialRoute: '/load_login',
      routes: {
        '/login': (context) => Login(),
        '/meals': (context) => Meals(),
        '/new_meal': (context) => NewMeal(),
        '/load_login': (context) => LoadLogin(),
        '/load_meals': (context) => LoadMeals(),
        '/settings': (context) => Settings(),
        '/load_grocery': (context) => LoadGroceryList(),
        '/grocery': (context) => Grocery(),
        '/new_grocery': (context) => NewGrocery(),
        '/ideas': (context) => Ideas(),
        '/new_idea': (context) => NewIdea(),
        '/load_ideas': (context) => LoadIdeas(),
        '/login_in': (context) => LoginIn(),
        '/login_up': (context) => LoginUp(),
        '/onboarding': (context) => OnboardingTab(),
      },
    );
  }
}


