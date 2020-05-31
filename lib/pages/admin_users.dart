import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoist/utils/theme.dart';

class DisplayUsers extends StatefulWidget {
  @override
  _DisplayUsersState createState() => _DisplayUsersState();
}

class _DisplayUsersState extends State<DisplayUsers> {
  @override
  Widget build(BuildContext context) {
    final _currentTheme = Provider.of<AppTheme>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(title:Text("Users",style: TextStyle(color: _currentTheme.font_color)),backgroundColor: _currentTheme.scaffold_color,),
      body: Container(
        child: FutureBuilder(
          future: Future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData) {
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                  return ;
                 },
                ),
              }
          },
        ),
      ),
    )
  }
}