// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoapi_app/constants/colors.dart';
import 'package:todoapi_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List Todo = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: TodoColors.secondary,
        onPressed: Addscreen,
        child: Icon(
          Icons.add,
          color: TodoColors.button,
        ),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: getTodo,
          child: ListView.builder(
              itemCount: Todo.length,
              itemBuilder: (context, index) {
                final Todos = Todo[index] as Map;
                final id = Todos['_id'] as String;
                return ListTile(
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  title: Text(
                    Todos['title'],
                    style: TextStyle(color: TodoColors.button),
                  ),
                  subtitle: Text(
                    Todos['description'],
                    style: TextStyle(color: TodoColors.button),
                  ),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == "edit ") {
                    } else if (value == "delete") {
                      DeleteTodo(id);
                    }
                  }, itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text("Edit"),
                        value: "edit",
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: "delete",
                      )
                    ];
                  }),
                );
              }),
        ),
      ),
    );
  }

  void Addscreen() {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoScreen(),
    );
    Navigator.push(context, route);
  }

  Future<void> getTodo() async {
    final Url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(Url);

    final response = await http.get(uri);
    print(response);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        Todo = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> DeleteTodo(String id) async {
    final Url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(Url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
//delete the Todo by id
    } else {
      // show some error message
    }
  }
}
