import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:todoist/api/update.dart';
import 'package:todoist/models/Models.dart';
import 'package:todoist/pages/profile_edit.dart';
import 'package:todoist/pages/settings.dart';
import 'package:todoist/utils/theme.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final _currentTheme = Provider.of<AppTheme>(context).currentTheme;

    return Scaffold(
      backgroundColor: _currentTheme.scaffold_color,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                ProfileDisplay(),
                SizedBox(
                  height: 100.0,
                ),
                TaskStatistic()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final _width = MediaQuery.of(context).size.width;
    final current_theme = Provider.of<AppTheme>(context).currentTheme;
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: _width,
            height: 250.0,
          ),
          Positioned.fill(
              top: 70.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: "Avatar",
                        child: CircleAvatar(
                     child: Text("${Provider.of<User>(context).username[0].toUpperCase()}",style: TextStyle(color:Colors.white,fontSize: 30.0),),
                     backgroundColor: Colors.purpleAccent,
                        radius: 35.0,
                      ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: ProfileEdit()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 35.0,
                            ),
                            AutoSizeText(
                              "${user.username}",
                              maxLines: 1,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: current_theme.font_color,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.edit,
                              size: 25.0,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "${user.email}",
                        style: TextStyle(color: current_theme.font_color),
                      )
                    ],
                  ),
                ),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                }),
          )
        ],
      ),
    );
  }
}

class TaskStatistic extends StatelessWidget {
  TaskStatistic();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context).currentTheme;
    final api = Api();

    final _width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20.0),
              color: theme.container_color),
          width: _width,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(2.0),
                              color: Colors.purple),
                          child: Icon(
                            Icons.done,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "Task Statistics",
                          style: TextStyle(
                              color: theme.font_color,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  // IconButton(
                  //     icon: Icon(
                  //       Icons.arrow_forward_ios,
                  //       color: Colors.white,
                  //     ),
                  //     onPressed: () {})
                ],
              ),
              Container(
                alignment: AlignmentDirectional.topStart,
                child: Column(
                  children: <Widget>[
                    FutureBuilder(
                      future: api.getCompletedTasks(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          var count = snapshot.data;
                          return Text(
                            "${snapshot.data}",
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: theme.font_color),
                          );
                        }
                        else{
                          return Text(
                            "0",
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: theme.font_color),
                          );
                        }
                      },
                    ),
                    Text(
                      "Total Completion",
                      style: TextStyle(
                        color: theme.font_color,
                        fontSize: 12.0,
                      ),
                    )
                  ],
                ),
              ),
              FutureBuilder(
                future: api.getGraphdetails(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return TweenAnimationBuilder(
                      duration: const Duration(seconds: 1, milliseconds: 5),
                      tween: Tween<double>(begin: 20.0, end: 5.0),
                      curve: Curves.easeOutCubic,
                      builder:
                          (BuildContext context, dynamic value, Widget child) {
                        return TaskChart(
                          maxTasks: value,
                          numberOfTasks: snapshot.data,
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),

              // TaskChart(
              //   maxTasks: 5.0,
              // )
            ],
          ),
        ));
  }
}

class TaskChart extends StatelessWidget {
  final maxTasks;
  final List<int> numberOfTasks;

  TaskChart({this.maxTasks, this.numberOfTasks});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context).currentTheme;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxTasks,
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            tooltipBottomMargin: 8,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                rod.y.round().toString(),
                TextStyle(
                  color: theme.font_color,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
                color: const Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 20,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return getDates(6);
                case 1:
                  return getDates(5);
                case 2:
                  return getDates(4);
                case 3:
                  return getDates(3);
                case 4:
                  return getDates(2);
                case 5:
                  return getDates(1);
                case 6:
                  return "Today";
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(showTitles: false),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(
                y: numberOfTasks[6].toDouble(), color: Colors.purpleAccent)
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(
                y: numberOfTasks[5].toDouble(), color: Colors.purpleAccent)
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(
                y: numberOfTasks[4].toDouble(), color: Colors.purpleAccent)
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(
                y: numberOfTasks[3].toDouble(), color: Colors.purpleAccent)
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(
                y: numberOfTasks[2].toDouble(), color: Colors.purpleAccent)
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(
                y: numberOfTasks[1].toDouble(), color: Colors.purpleAccent)
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 7, barRods: [
            BarChartRodData(
                y: numberOfTasks[0].toDouble(), color: Colors.purpleAccent)
          ], showingTooltipIndicators: [
            0
          ]),
        ],
      ),
    );
  }
}

String getDates(int days) {
  var _currDate = DateTime.now();
  var calc_date = (_currDate.subtract(Duration(days: days)).day);
  if (calc_date == 1 || calc_date == 21)
    return "${calc_date}st";
  else if (calc_date == 2 || calc_date == 22)
    return "${calc_date}nd";
  else if (calc_date == 3 || calc_date == 23)
    return "${calc_date}rd";
  else
    return "${calc_date}th";
}
