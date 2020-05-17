import 'package:flutter/material.dart';
import 'package:todoist/app/landing_page.dart';
import 'package:todoist/app/lists/add_list_page.dart';
import 'package:todoist/app/lists/display_list_of_user.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DisplayListOfUser();
  }
}
