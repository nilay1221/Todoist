import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/app/landing_page.dart';
import 'package:todoist/models/Models.dart';
import 'package:todoist/utils/theme.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final apptheme = Provider.of<AppTheme>(context);
    final theme = Provider.of<AppTheme>(context).currentTheme;
    final user = Provider.of<User>(context);
    final navigatorKey = GlobalKey<NavigatorState>();
    bool _value = !apptheme.themeSelected;

    print(apptheme.themeSelected);
    return Scaffold(
      backgroundColor: theme.scaffold_color,
      appBar: AppBar(
        backgroundColor: theme.scaffold_color,
        title: Text(
          "Settings",
          style: TextStyle(color: theme.font_color),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.font_color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SwitchListTile(
                title: Text(
                  "Dark Theme",
                  style: TextStyle(color: theme.font_color),
                ),
                value: _value,
                onChanged: (bool value) {
                  setState(() {
                    _value = value;
                    Provider.of<AppTheme>(context, listen: false)
                      .selectTheme(!value);
                  });
                }),
            ListTile(
              title: Text('Logout',
              style: TextStyle(color:theme.font_color),
              ),
              onTap: ()  async{
                bool isLogout = await showDialog(context: context,
                builder: (context) => LogoutDialog()
                );
                if(isLogout) {
                    await user.logoutUser();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>LandingPage()), (Route<dynamic> route) => false);

                }
              },
            )
          ],
        ),
      ),
    );
  }
}



class LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("Logout"),
      content: Container(
        height: 20.0,
        width: 100.0,
        child: Text("Are you sure want to Log Out ?"),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes"),
          onPressed: () {
            Navigator.pop(context,true);
          },
        ),
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context,false);
          },
        )
      
      ],
    );
  }
}








class ThemeDialog extends StatefulWidget {
  int _groupvalue;
  int intialGroupValue;
  // AppTheme theme ;

  ThemeDialog(int value)
      : _groupvalue = value,
        intialGroupValue = value;

  @override
  _ThemeDialogState createState() =>
      _ThemeDialogState(_groupvalue, intialGroupValue);
}

class _ThemeDialogState extends State<ThemeDialog> {
  int _groupvalue;
  int intialGroupValue;
  // AppTheme theme;
  _ThemeDialogState(this._groupvalue, this.intialGroupValue);

  @override
  Widget build(BuildContext context) {
    // final theme = Provider.of<AppTheme>(context).currentTheme;
    final List<String> themeOptions = ['Light Theme', 'Dark Theme'];
    return Consumer<AppTheme>(builder: (context, apptheme, child) {
      final theme = apptheme.currentTheme;
      return AlertDialog(
        backgroundColor: theme.container_color,
        title: Text(
          "Choose Theme",
          style: TextStyle(color: theme.font_color),
        ),
        content: Container(
          color: theme.container_color,
          height: 120.0,
          child: Column(
            children: <Widget>[
              RadioListTile(
                  title: Text(
                    themeOptions[0],
                    style: TextStyle(color: theme.font_color),
                  ),
                  value: 0,
                  groupValue: _groupvalue,
                  onChanged: (int i) {
                    setState(() {
                      _groupvalue = i;
                    });
                  }),
              RadioListTile(
                title: Text(themeOptions[1],
                    style: TextStyle(color: theme.font_color)),
                value: 1,
                groupValue: _groupvalue,
                onChanged: (int i) {
                  setState(() {
                    _groupvalue = i;
                  });
                },
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: theme.font_color),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text("OK", style: TextStyle(color: theme.font_color)),
            onPressed: () {
              if (intialGroupValue != _groupvalue) {
                if (_groupvalue == 0)
                  Provider.of<AppTheme>(context, listen: false)
                      .selectTheme(true);
                else
                  Provider.of<AppTheme>(context, listen: false)
                      .selectTheme(false);
                Navigator.pop(context);
              }
            },
          )
        ],
      );
    });
  }
}
