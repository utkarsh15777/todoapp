// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/utills/dialog_box.dart';
import 'package:todoapp/utills/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('localStorage');

  final _controller=TextEditingController();

  TodoDatabase db=TodoDatabase();

  @override
  void initState() {
    super.initState();
    if(_myBox.get("TODOLIST") == null){
      db.createInitialdata();
    }else{
      db.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text(
          "TODO APP",
          style: TextStyle(
            fontWeight: FontWeight.w800
          ),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(
          Icons.add
        ),
      ),
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index){
          return TodoTile(
            taskName: db.todoList[index][0], taskCompleted: db.todoList[index][1], onChanged: (value) => checkBoxChanged(value,index),
            deleteFunction: (context) => deleteTask(index),
          );
        }
      ),
    );
  }
  
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1]=!db.todoList[index][1];
    });
    db.updataData();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: ()=> Navigator.of(context).pop(),
        );
      });
  }

  void saveNewTask() {
    setState(() {
      db.todoList.add([_controller.text,false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updataData();
  }
  
  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updataData();
  }
}