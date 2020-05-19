import 'package:flutter/material.dart';
import 'package:todoist/app/lists/add_list_page.dart';

class Task {
  Task({this.task, this.starColor, this.circleColor});
  final String task;
  Color starColor;
  Color circleColor;
}

class DisplayListOfUser extends StatefulWidget {
  @override
  _DisplayListOfUserState createState() => _DisplayListOfUserState();
}

class _DisplayListOfUserState extends State<DisplayListOfUser> {
  List<Task> task = [
    Task(
        task: 'Deep learning',
        starColor: Colors.white,
        circleColor: Colors.black),
    Task(task: 'Flutter', starColor: Colors.white, circleColor: Colors.black),
    Task(
        task: 'Going to Gym',
        starColor: Colors.white,
        circleColor: Colors.black)
  ];

  void _addNewTask() {
    Navigator.of(context).push(
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) {
            return AddListPage();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Tasks',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 25,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: task.length,
          itemBuilder: (BuildContext context, index) {
            return ListTile(
              leading: FlatButton(
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 11,
                    backgroundColor: task[index].circleColor,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    task[index].circleColor =
                        task[index].circleColor == Colors.black
                            ? Colors.teal
                            : Colors.black;
                  });
                },
              ),
              title: Text('${task[index].task}',
                  style: TextStyle(color: Colors.white)),
              trailing: FlatButton(
                child: Icon(
                  Icons.star,
                  color: task[index].starColor,
                ),
                onPressed: () {
                  setState(() {
                    task[index].starColor =
                        task[index].starColor == Colors.white
                            ? Colors.teal
                            : Colors.white;
                  });
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FlatButton(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add_circle_outline,
              color: Colors.tealAccent,
            ),
            Text(
              'Add new task',
              style: TextStyle(color: Colors.tealAccent),
            ),
          ],
        ),
        onPressed: _addNewTask,
      ),
    );
  }
}
