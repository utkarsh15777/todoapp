import 'package:hive/hive.dart';

class TodoDatabase{
  final _myBox=Hive.box("localStorage");

  List todoList=[];

  void createInitialdata(){
    todoList=[
      ["Create Tutorial",false],
      ["Learn Flutter",false],
    ];
  }

  void loadData(){
    todoList = _myBox.get("TODOLIST");
  }

  void updataData(){
    _myBox.put("TODOLIST", todoList);
  }

}