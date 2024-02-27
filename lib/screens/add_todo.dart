// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todoapi_app/constants/api.dart';
import 'package:todoapi_app/constants/colors.dart';
import 'package:http/http.dart' as http;

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Todo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Form(
              key: formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: "Enter Title"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter Title";
                      } else if (value.length <= 3) {
                        return "Please enter atleast 3 Characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(hintText: "Enter Description"),
                    minLines: 2,
                    maxLines: 8,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter the Description";
                      } else if (value.length <= 3) {
                        return "Please enter atleast 3 Characters";
                      }
                      return null;
                    },
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  final todotitle = titleController.text;
                  final tododescription = descriptionController.text;
                  final body = {
                    "title": todotitle,
                    "description": tododescription,
                    "is_completed": false
                  };

                  try {
                    final response = await http.post(
                        Uri.parse("https://api.nstack.in/v1/todos"),
                        body: jsonEncode(body),
                        headers: {'Content-Type': ' application/json'});

                    print(response.statusCode);
                    if (response.statusCode == 201) {
                      titleController.text = '';
                      descriptionController.text = '';
                      print("data added");
                      successmessage("Todo Added Successfully");
                    }
                  } catch (e) {
                    print(e);

                    errormessage("Creation Failed");
                    print("error happen");
                  }
                } else {
                  return null;
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue)),
              child: Text(
                "Submit",
                style: TextStyle(color: TodoColors.button),
              ))
        ],
      ),
    );
  }

  void successmessage(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void errormessage(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: TodoColors.button),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
