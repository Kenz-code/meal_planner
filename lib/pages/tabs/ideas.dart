import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:meal_planner/pages/tabs/new_idea.dart';
import 'package:meal_planner/widgets/global/drawer.dart';
import 'package:meal/meal.dart';

class Ideas extends StatefulWidget {
  const Ideas({super.key});

  @override
  State<Ideas> createState() => _IdeasState();
}

class _IdeasState extends State<Ideas> {

  var data;
  var ideas;
  int sort_index = 0;

  void new_idea() {
    Navigator.of(context).pushNamed('/new_idea');
  }

  Future<void> _onRefresh() async {
    Navigator.of(context).pushReplacementNamed('/load_ideas');
  }

  void sortIdeas() {
    switch (sort_index){
      case 0:
        ideas.sort( (a,b) => a['name'].toLowerCase().compareTo(b['name'].toLowerCase()) as int );
      case 1:
        ideas.sort( (a,b) => a['person'].toLowerCase().compareTo(b['person'].toLowerCase()) as int );
    }

  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context)?.settings.arguments;
    ideas = data["ideas"];
    sortIdeas();

    // if no meals, do this \/
    if (ideas.isEmpty) {
      return Scaffold(
        drawer: CustomDrawer(index: 2),
        appBar: MealAppbar(
          label: "Meal Ideas",
          darkMode: MealApp.of(context).darkMode!,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MealRefresh(
              onRefresh: _onRefresh,
              child: Center(child: MealText.body("Press the + to create an idea.",))
          ),

        ),
        floatingActionButton: MealFloatingButton(
          onPressed: new_idea,
          child: Icon(Icons.add_rounded),
        ),
      );
    }

    return Scaffold(
      drawer: CustomDrawer(index: 2),
      appBar: MealAppbar(
        label: 'Meal Ideas',
        darkMode: MealApp.of(context).darkMode!,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: MealRefresh(
          onRefresh: _onRefresh,
          child: Column(
            children: [
              MealSortBy(chips: ["Idea", 'Person'], onSelected: (index) {setState(() {
                sort_index = index;
              });},),
              SizedBox(height: 7,),
              MealDivider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onLongPress: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => IdeaCardDialog(ideas: ideas, index: index)
                      ),
                      child: MealCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MealText.body(ideas[index]['name'], lessImportant: true),
                            MealText.body(ideas[index]['person'], lessImportant: true),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 4);
                  },
                  itemCount: ideas != null ? ideas.length : 0,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MealFloatingButton(
        onPressed: new_idea,
        child: Icon(Icons.add_rounded),
      ),
    );
  }
}

class IdeaCardDialog extends StatelessWidget {

  final ideas;
  final index;

  const IdeaCardDialog({super.key, this.ideas, this.index});

  void edit_idea(context) async {
    var auth = FirebaseAuth.instance.currentUser;
    if (auth == null) {return;}

    FirebaseFirestore.instance.collection('ideas').doc(auth.uid).update({
      'ideas': FieldValue.arrayRemove([ideas[index]])
    });

    Navigator.of(context).pushNamed('/new_idea', arguments: ideas[index]);
  }

  Widget notes() {
    print(ideas[index]['notes']);
    return ideas[index]['notes'] == null ?
    SizedBox.shrink() :
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MealText.title("Notes", align: TextAlign.start,),
        SizedBox(height: 8,),
        MealText.body(ideas[index]['notes'], align: TextAlign.start,),
        SizedBox(height: 16,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MealDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          notes(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: MealButton.primary(onPressed: () { edit_idea(context); }, label: "Edit")),
              SizedBox(width: 8,),
              Expanded(
                child: MealButton.primary(onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => IdeaDeleteAlertDialog(ideas: ideas, index: index,)
                ), label: 'Delete'),
              )
            ]
          ),
        ],
      ),
    );
  }
}

class IdeaDeleteAlertDialog extends StatelessWidget {

  final List ideas;
  final int index;

  const IdeaDeleteAlertDialog({super.key, required this.ideas, required this.index});

  void delete_idea(context) {
    var auth = FirebaseAuth.instance.currentUser;
    if (auth == null) {return;}

    FirebaseFirestore.instance.collection('ideas').doc(auth.uid).update({
      'ideas': FieldValue.arrayRemove([ideas[index]])
    });

    Navigator.of(context).pushReplacementNamed("/load_ideas");
  }

  @override
  Widget build(BuildContext context) {
    return MealAlertDialog(
      title: "Delete idea",
      content: "Are you sure you want to delete this idea?",
      actions: <Widget>[
        MealButton.primary_outline(
          onPressed: () => Navigator.pop(context),
          label: 'Cancel',
        ),
        MealButton.primary(
          onPressed: () => delete_idea(context),
          label: 'Delete',
        ),
      ],
    );
  }
}

