import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();
  HomePage() {
    // items.add(Item(title: "Atividade 1", done: false));
    // items.add(Item(title: "Atividade 2", done: true));
    // items.add(Item(title: "Atividade 3", done: false));
  }
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var todoCtrl = new TextEditingController();
  void add() {
    setState(() {
      widget.items.add(Item(title: todoCtrl.text, done: false));
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((e) => Item.fromJson(e)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: todoCtrl,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            var item = widget.items[index];
            return Dismissible(
              key: UniqueKey(),
              child: CheckboxListTile(
                title: Text(item.title),
                value: item.done,
                onChanged: (value) {
                  setState(() {
                    item.done = value;
                    save();
                  });
                },
              ),
              background: Container(
                color: Colors.red.withOpacity(0.2),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  remove(index);
                } else {
                  setState(() {
                    print("Oi");
                  });
                }
              },
            );
          },
          itemCount: widget.items.length,
        ),
      ),
    );
  }
}
