import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDo extends StatefulWidget {
  final Map? item;
  const AddToDo({super.key, this.item});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  bool isEdit = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data = widget.item;
    if (widget.item != null) {
      isEdit = true;
      titleController.text = widget.item!['title'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit To Do" : "Add To Do"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: "Title"),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descController,
            decoration: InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 5,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : sumbmitData,
            child: Text(isEdit ? "Update" : "Submit"),
          )
        ],
      ),
    );
  }

  Future<void> sumbmitData() async {
    final title = titleController.text;
    final description = descController.text;
    final is_completed = true;

    final headers = {'Content-Type': 'application/json'};

    final body = {
      "title": title,
      "description": description,
    };
    final url = Uri.parse("http://192.168.0.123:5084/api/ToDo/addtodo");
    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);

    print(body);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 201) {
      titleController.text = "";
      descController.text = "";
      successMessage("Added successful");
      print(response.body);
    } else {
      errorMessage("An error has occured");
    }
  }

  Future<void> updateData() async {
    final title = titleController.text;
    final description = descController.text;
    final is_completed = true;

    final headers = {'Content-Type': 'application/json'};

    final body = {
      "title": title,
      "decription": description,
      "is_completed": is_completed
    };
    final id = widget.item?['_id'];
    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    http.Response response =
        await http.put(url, body: jsonEncode(body), headers: headers);

    if (response.statusCode == 200) {
      successMessage("Updated successful");
      print(response.body);
    } else {
      errorMessage("An error has occured");
    }
  }

  void successMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void errorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
