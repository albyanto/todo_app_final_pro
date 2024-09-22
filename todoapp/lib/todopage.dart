import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:todoapp/splash.dart';

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<String> todoList = [];
  TextEditingController todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTodoList();
  }

  // Save the to-do list in shared preferences
  Future<void> saveTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('todoList', jsonEncode(todoList));
  }

  // Load the to-do list from shared preferences
  Future<void> loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todoListString = prefs.getString('todoList');
    if (todoListString != null) {
      setState(() {
        todoList = List<String>.from(jsonDecode(todoListString));
      });
    }
  }

  void addTodoItem() {
    if (todoController.text.isNotEmpty) {
      setState(() {
        todoList.add(todoController.text);
      });
      todoController.clear();
      saveTodoList();
    }
  }

  void removeTodoItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
    saveTodoList();
  }

  void updateTodoItem(int index, String updatedText) {
    setState(() {
      todoList[index] = updatedText;
    });
    saveTodoList();
  }

  void showUpdateDialog(int index) {
    TextEditingController updateController = TextEditingController();
    updateController.text = todoList[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update To-Do Item'),
          content: TextField(
            controller: updateController,
            decoration: InputDecoration(hintText: 'Update your to-do'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (updateController.text.isNotEmpty) {
                  updateTodoItem(index, updateController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Todo App"),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                  onPressed: () async {
                    // await saveBoolData(false);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SplashScreen(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, //text color
                    backgroundColor:
                        Color.fromARGB(255, 73, 147, 245), //button color
                  ),
                  child: Text(
                    "Log  Out",
                  )),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    controller: todoController,
                    decoration: InputDecoration(
                        hintText: 'Add a new task',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, //text color
                      backgroundColor: Colors.blue, //button color
                    ),
                    onPressed: addTodoItem,
                    child: Text("Add")),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ListTile(
                      title: Text(
                        todoList[index],
                        style: TextStyle(
                            color: const Color.fromARGB(255, 254, 254, 254)),
                      ),
                      onTap: () => showUpdateDialog(
                          index), // Open update dialog when tapped
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () => removeTodoItem(index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
