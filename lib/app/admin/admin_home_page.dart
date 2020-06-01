import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:todoist/app/admin/blocked_user_page.dart';
import 'package:todoist/app/admin/unblocked_user_page.dart';
import 'package:todoist/pages/admin_dashboard.dart';
import 'package:todoist/pages/settings.dart';
import 'package:todoist/utils/theme.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _totalBlockedUser;
  int _totalUnblockedUser;

  @override
  void initState() {
    super.initState();
    totalUser();
  }

  void totalUser() async {
    String url = "https://todoistapi.000webhostapp.com/admin_stats.php";
    Map data = {"id": "2"};
    var jsonData = jsonEncode(data);
    var response = await http.post(Uri.encodeFull(url), body: jsonData);
    if (response.statusCode == 200) {
      var finalData = jsonDecode(response.body.toString());
      print(finalData);
      setState(() {
        _totalBlockedUser = finalData["allBlockedUsers"];
        _totalUnblockedUser = finalData["allUnblockedUsers"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _currentTheme = Provider.of<AppTheme>(context).currentTheme;
    return Scaffold(
      backgroundColor: _currentTheme.scaffold_color,
      appBar: AppBar(
        backgroundColor: _currentTheme.scaffold_color,
        title: Text('Home Page',style: TextStyle(color: _currentTheme.font_color),),
        centerTitle: true,
        titleSpacing: 1.0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings,color: _currentTheme.font_color,), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder:(context) => Settings() ));
          })
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildContent(context),
          dashboardButton(context)

        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final _currentTheme = Provider.of<AppTheme>(context).currentTheme;
    print(_currentTheme.container_color);
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: RaisedButton(
                color: _currentTheme.container_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Blocked User',
                        style: TextStyle(fontSize: 20,color: _currentTheme.font_color),
                      ),
                      Text(
                        "$_totalBlockedUser",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: _currentTheme.font_color),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => BlockedUserPage(
                        totalUser: totalUser,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: RaisedButton(
                color: _currentTheme.container_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Unblocked User',
                        style: TextStyle(fontSize: 20,color: _currentTheme.font_color),
                      ),
                      Text(
                        "$_totalUnblockedUser",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: _currentTheme.font_color),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => UnBlockedUserPage(
                        totalUser: totalUser,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


Widget dashboardButton(BuildContext context) {
    final _currentTheme = Provider.of<AppTheme>(context).currentTheme;
  return SizedBox(
    height: 50.0,
      child: RaisedButton(
      color: _currentTheme.container_color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      child: Text("View Dashboard",style: TextStyle(color:_currentTheme.font_color),),
      onPressed: () {
      Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => DashboarLoading(
                      ),
                    ),
                  );
      }
    ),
  );

}
