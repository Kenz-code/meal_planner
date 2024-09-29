import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:meal_planner/pages/tabs/new_meal.dart';
import 'package:meal_planner/widgets/global/drawer.dart';
import 'package:meal/meal.dart';

class Meals extends StatefulWidget {
  const Meals({super.key});

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {

  var data;
  var meals;
  var meals_by_day = {};
  var meals_by_day_list;

  void new_meal() {
    Navigator.of(context).pushNamed('/new_meal');
  }

  void edit_meal(Map _data) {
    var auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      FirebaseFirestore.instance.collection('meals').doc(auth.uid).update({
        'meals': FieldValue.arrayRemove([_data])
      });

      Navigator.of(context).pushNamed('/new_meal', arguments: _data);
    }
  }

  String formatMealType(int mealType) {
    switch (mealType){
      case 0:
        return "Breakfast";
      case 1:
        return "Lunch";
      case 2:
        return "Supper";
    }
    return "";
  }

  Icon formatMealTypeIcon(int mealType) {
    switch (mealType){
      case 0:
        return Icon(Icons.breakfast_dining_rounded, size: 14, color: MealApp.of(context).darkMode! ? neutral300 : neutral900);
      case 1:
        return Icon(Icons.lunch_dining_rounded, size: 14, color: MealApp.of(context).darkMode! ? neutral300 : neutral900);
      case 2:
        return Icon(Icons.dinner_dining_rounded, size: 14, color: MealApp.of(context).darkMode! ? neutral300 : neutral900);
    }
    return Icon(Icons.ac_unit);
  }

  void sortMeals() {
    for (var meal in meals) {
      if (meal['date'].runtimeType == Timestamp) {
        meal['date'] = meal['date'].toDate();
      }
    }

    meals.sort((a, b) {
      // Custom comparison function
      if (a['date'].isAfter(b['date'])) {
        return 1;
      } else if (a['date'].isBefore(b['date'])) {
        return -1;
      } else {
        return 0;
      }
    });

    for (var meal in meals) {
      if (meals_by_day.containsKey(meal['date'])) {
        meals_by_day[meal['date']].add(meal);
      } else {
        meals_by_day[meal['date']] = [];
        meals_by_day[meal['date']].add(meal);
      }
    }
    meals_by_day_list = meals_by_day.keys.toList();

  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();

    return now.year == date.year && now.month == date.month && now.day == date.day;
  }

  Future<void> _onRefresh() async {
    Navigator.of(context).pushReplacementNamed('/load_meals');
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context)?.settings.arguments;
    meals = data["meals"];
    sortMeals();

    // if no meals, do this \/
    if (meals.isEmpty) {
      return Scaffold(
        drawer: CustomDrawer(index: 0),
        appBar: MealAppbar(
          label: "Meals",
          darkMode: MealApp.of(context).darkMode!,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MealRefresh(
              onRefresh: _onRefresh,
              child: Center(child: MealText.body("Press the + to create a meal.",))
          ),

        ),
        floatingActionButton: MealFloatingButton(
          onPressed: new_meal,
          child: Icon(Icons.add_rounded),
        ),
      );
    }

    return Scaffold(
      drawer: CustomDrawer(index: 0),
      appBar: MealAppbar(
        label: "Meals",
        darkMode: MealApp.of(context).darkMode!,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: MealRefresh(
          onRefresh: _onRefresh,
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                var weekday_text = isToday(meals[index]['date']) ? "Today" : DateFormat.EEEE().format(meals[index]["date"]).toString();
                return GestureDetector(
                  onLongPress: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => MealCardDialog(meals: meals, index: index, edit_meal: (var _meal) {edit_meal(_meal);},)
                  ),
                  child: MealCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            MealText.heading(weekday_text),
                            SizedBox(width: 8),
                            MealText.label(DateFormat.MMMMd().format(meals[index]["date"]).toString())
                          ],),
                        SizedBox(height:8),
                        MealText.body(meals[index]['name']),
                        SizedBox(height:8),
                        Row(
                          children: [
                            formatMealTypeIcon(meals[index]["meal_type"]),
                            SizedBox(width: 4,),
                            MealText.label(formatMealType(meals[index]['meal_type']), lessImportant: true,),
                            Expanded(child: MealText.label(meals[index]['person'], align: TextAlign.end, lessImportant: true))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8);
              },
              itemCount: meals != null ? meals.length : 0,
          ),
        ),
      ),
      floatingActionButton: MealFloatingButton(
        onPressed: new_meal,
        child: Icon(Icons.add_rounded),
      ),
    );
  }
}

class MealCardDialog extends StatelessWidget {

  final meals;
  final index;
  final Function edit_meal;

  Widget notes() {
    print(meals[index]['notes']);
    return meals[index]['notes'] == null ? 
    SizedBox.shrink() : 
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MealText.title("Notes", align: TextAlign.start,),
        SizedBox(height: 8,),
        MealText.body(meals[index]['notes'], align: TextAlign.start,),
        SizedBox(height: 16,),
      ],
    );
  }

  const MealCardDialog({super.key, this.meals, this.index, required this.edit_meal});

  @override
  Widget build(BuildContext context) {
    return MealDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          notes(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: MealButton.primary(onPressed: () { edit_meal(meals[index]); }, label: "Edit")),
              SizedBox(width: 8),
              Expanded(
                child: MealButton.primary(onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => DeleteMealAlertDialog(meals: meals, index: index,)
                ), label: 'Delete'),
              )
            ]
          ),
        ],
      )
    );
  }
}

class DeleteMealAlertDialog extends StatelessWidget {

  final meals;
  final index;

  const DeleteMealAlertDialog({super.key, this.meals, this.index});

  void delete_meal(index, context) {
    var auth = FirebaseAuth.instance.currentUser;
    if (auth == null) {return;}

    FirebaseFirestore.instance.collection('meals').doc(auth.uid).update({
      'meals': FieldValue.arrayRemove([meals[index]])
    });

    Navigator.of(context).pushReplacementNamed("/load_meals");
  }

  @override
  Widget build(BuildContext context) {
    return MealAlertDialog(
        actions: <Widget>[
          MealButton.primary_outline(onPressed: () => Navigator.pop(context), label: 'Cancel'),
          MealButton.primary(onPressed: () => delete_meal(index, context), label: "Delete")
        ],
        title: "Delete meal",
        content: "Are you sure you want to delete this meal?"
    );
  }
}

