import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoist/utils/theme.dart';

class Dashboard  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _currentTheme = Provider.of<AppTheme>(context).currentTheme;
    return Scaffold(
      backgroundColor: _currentTheme.scaffold_color,
      body: SafeArea(
              child: Container(
          child: Column(
            children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Dashboard",
                        
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}



