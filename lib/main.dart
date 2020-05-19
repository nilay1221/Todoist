import 'package:flutter/material.dart';
import 'package:todoist/app/wrapper.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrapper();
  }
}
