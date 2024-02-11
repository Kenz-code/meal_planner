import 'package:flutter/material.dart';
import 'package:meal_planner/widgets/global/drawer.dart';
import 'package:meal_planner/pages/tabs/new_grocery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal/meal.dart';

class Grocery extends StatefulWidget {
  const Grocery({super.key});

  @override
  State<Grocery> createState() => _GroceryState();
}

class _GroceryState extends State<Grocery> {

  var grocery_list;
  var data;

  List produce = [];
  List dairy = [];
  List frozen = [];
  List bread = [];
  List meat = [];
  List other = [];

  void sort_groceries() {
    grocery_list.asMap().forEach( (index, value) {
      value['list_index'] = index;
      switch (value['grocery_type']) {
        case 0:
          produce.add(value);
        case 1:
          dairy.add(value);
        case 2:
          frozen.add(value);
        case 3:
          bread.add(value);
        case 4:
          meat.add(value);
        case 5:
          other.add(value);
      }
    });

    //sort alphabetically
    produce.sort( (a,b) => a['name'].toLowerCase().compareTo(b['name'].toLowerCase()) );
    dairy.sort( (a,b) => a['name'].compareTo(b['name']) );
    frozen.sort( (a,b) => a['name'].compareTo(b['name']) );
    bread.sort( (a,b) => a['name'].compareTo(b['name']) );
    meat.sort( (a,b) => a['name'].compareTo(b['name']) );
    other.sort( (a,b) => a['name'].compareTo(b['name']) );

    /* for (var grocery in grocery_list) {
      grocery['list_index'] = ;
      switch (grocery['grocery_type']) {
        case 0:
          produce.add(grocery);
        case 1:
          dairy.add(grocery);
        case 2:
          frozen.add(grocery);
        case 3:
          bread.add(grocery);
        case 4:
          meat.add(grocery);
        case 5:
          other.add(grocery);
      }
    }*/
  }

  void new_grocery() {
    Navigator.of(context).pushNamed('/new_grocery');
  }

  Future<void> _onRefresh() async {
    Navigator.of(context).pushReplacementNamed('/load_grocery');
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context)?.settings.arguments;
    grocery_list = data["grocery_list"];
    sort_groceries();

    return Scaffold(
      drawer: CustomDrawer(index: 1),
      appBar: MealAppbar(
        label: "Grocery List",
        darkMode: MealApp.of(context).darkMode!,
      ),
      floatingActionButton: MealFloatingButton(
        onPressed: new_grocery,
        child: Icon(Icons.add_rounded)
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: MealRefresh(
            onRefresh: _onRefresh,
            child: ListView(
              children: [
                Category(name: "Produce", groceries: produce, main_grocery_list: grocery_list,),
                Category(name: "Dairy", groceries: dairy, main_grocery_list: grocery_list),
                Category(name: "Frozen", groceries: frozen, main_grocery_list: grocery_list),
                Category(name: "Bread/Pastry", groceries: bread, main_grocery_list: grocery_list),
                Category(name: "Meat/Poultry", groceries: meat, main_grocery_list: grocery_list),
                Category(name: "Other", groceries: other, main_grocery_list: grocery_list),
              ]
            ),
          ),
        )
    );
  }
}

class Category extends StatelessWidget {
  final String name;
  final List groceries;
  final List main_grocery_list;

  const Category({super.key, required this.name, required this.groceries, required this.main_grocery_list});

  @override
  Widget build(BuildContext context) {

    // show nothing if there is no groceries
    if (groceries.isEmpty){return SizedBox.shrink();}

    var head_theme = Theme.of(context).textTheme.titleMedium;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: MealGroceryHeader(
            title: name,
          )
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: groceries.length,
          itemBuilder: (BuildContext context, int index) => GroceryTile(grocery_list: main_grocery_list, index: groceries[index]['list_index'])
        ),
        MealDivider(height: 16)
      ],
    );
  }
}


class GroceryTile extends StatefulWidget {
  final List grocery_list;
  final int index;

  const GroceryTile({super.key, required this.grocery_list, required this.index});

  @override
  State<GroceryTile> createState() => _GroceryTileState();
}

class _GroceryTileState extends State<GroceryTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: MealText.body(widget.grocery_list[widget.index]['name'], lessImportant: true),
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => GroceryDeleteAlertDialog(grocery_list: widget.grocery_list, index: widget.index)
      ),
      onLongPress: () => showDialog(
          context: context,
          builder: (BuildContext context) => GroceryEditAlertDialog(grocery_list: widget.grocery_list, index: widget.index)
      ),
    );
  }
}

class GroceryDeleteAlertDialog extends StatelessWidget {

  final List grocery_list;
  final int index;

  const GroceryDeleteAlertDialog({super.key, required this.grocery_list, required this.index});

  void delete_meal(context) async {
    var auth = FirebaseAuth.instance.currentUser;
    if (auth == null) {return;}

    if (grocery_list[index].containsKey('list_index')) {grocery_list[index].remove('list_index');}
    await FirebaseFirestore.instance.collection('grocery_list').doc(auth.uid).update({
      'grocery_list': FieldValue.arrayRemove([grocery_list[index]])
    });

    Navigator.of(context).pushReplacementNamed("/load_grocery");
  }

  @override
  Widget build(BuildContext context) {
    return MealAlertDialog(
      title: "Delete grocery",
      content: "Are you sure you want to delete this grocery?",
      actions: <Widget>[
        MealButton.primary_outline(
          onPressed: () => Navigator.pop(context),
          label: 'Cancel',
        ),
        MealButton.primary(
          onPressed: () => delete_meal(context),
          label: 'Delete',
        ),
      ],
    );
  }
}

class GroceryEditAlertDialog extends StatelessWidget {

  final List grocery_list;
  final int index;

  const GroceryEditAlertDialog({super.key, required this.grocery_list, required this.index});

  void edit_meal(context) async {
    var auth = FirebaseAuth.instance.currentUser;
    if (auth == null) {return;}

    if (grocery_list[index].containsKey('list_index')) {grocery_list[index].remove('list_index');}
    await FirebaseFirestore.instance.collection('grocery_list').doc(auth.uid).update({
      'grocery_list': FieldValue.arrayRemove([grocery_list[index]])
    });

    Navigator.of(context).pushNamed('/new_grocery', arguments: grocery_list[index]);
  }

  @override
  Widget build(BuildContext context) {
    return MealAlertDialog(
      title: "Edit grocery",
      content: "Are you sure you want to edit this grocery?",
      actions: <Widget>[
        MealButton.primary_outline(
          onPressed: () => Navigator.pop(context),
          label: 'Cancel',
        ),
        MealButton.primary(
          onPressed: () => edit_meal(context),
          label: 'Delete',
        ),
      ],
    );
  }
}




