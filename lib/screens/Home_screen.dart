import 'dart:convert';

import 'package:crud/screens/add_page.dart';
import 'package:crud/services/todo_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do App"),
      ),
      body: Visibility(
        visible: items.isNotEmpty,
        replacement: Center(
          child: Text(
            "No To Do Items",
            style: TextStyle(fontSize: 32),
          ),
        ),
        child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    item['title'],
                  ),
                  // subtitle: Text(
                  //   item['description'],
                  // ),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == "edit") {
                        navigateToEditToDo(item);
                      } else {
                        deleteById(id);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text("Edit"),
                          value: "edit",
                        ),
                        PopupMenuItem(child: Text("Delete"), value: "delete"),
                      ];
                    },
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddToDo();
        },
        label: Text("Add ToDo"),
      ),
    );
  }

  Future<void> navigateToAddToDo() async {
    final route = MaterialPageRoute(builder: (context) => AddToDo());
    await Navigator.push(context, route);
    setState(() => isLoading = true);
    getData();
  }

  Future<void> navigateToEditToDo(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddToDo(item: item));
    await Navigator.push(context, route);
    setState(() => isLoading = true);
    getData();
  }

  Future<void> getData() async {
    final url = Uri.parse("https://api.nstack.in/v1/todos");
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() => items = result);
    }

    setState(() => isLoading = false);
  }

  Future<void> deleteById(String id) async {
    var isSuccess = await ToDoServices.deleteItem(id);
    if (isSuccess == 200) {
      final filtred = items.where((element) => element['_id'] != id).toList();
      setState(() => items = filtred);
    }
  }
}
