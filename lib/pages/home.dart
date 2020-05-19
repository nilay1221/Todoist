import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/app/landing_page.dart';
import 'package:todoist/app/lists/add_list_page.dart';
import 'package:todoist/app/lists/display_list_of_user.dart';
import 'package:todoist/models/Models.dart';
import 'package:todoist/pages/profile.dart';
import 'package:todoist/utils/theme.dart';



class HomeLoading extends StatefulWidget {
  @override
  _HomeLoadingState createState() => _HomeLoadingState();
}

class _HomeLoadingState extends State<HomeLoading> {

  Future<Map> getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var isUserlogin = preferences.getBool('userlogin') ?? false;
    if(isUserlogin)
    {
      bool isLight = await getCurrentTheme();
      return {'islogin':true,'theme':isLight};
    }

    return {'islogin':false};
    // if(isUserlogin) {
    //     var username = preferences.getString('username');
    //     var email = preferences.getString('email');
    //     var token  = preferences.getString('token');
    //     bool isLight = preferences.getBool('isLight') ?? false;

    //     AppTheme appTheme = new AppTheme(isLight);
    //      return {'user': user,'theme':appTheme,'msg':"loggedin"};
    // }
    // else{
    //   return {'msg':'loggedout'};
    // }

  }

  Future<bool> getCurrentTheme() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isLight = preferences.getBool('isLight') ?? false;
  return isLight;
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(

        child: Container(
          child: FutureBuilder(
            future: getUserDetails(),
            builder: (context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                print(snapshot.data);
                if(snapshot.data['islogin']){
                    Provider.of<User>(context,listen: false).getUser();
                    Provider.of<AppTheme>(context,listen: false).selectTheme(snapshot.data['theme']);
                    return HomeDisplay();
                }
                else{

                  print("User not authenticated");
                  return LandingPage();
                }
                
              }
              return Center(
                child: Text("TodoList"),
              );
            },
          ),
        ),
        ),
    );
  }
}


class HomeLoggedIn extends StatelessWidget {

  final AppTheme theme ;
  final User user;

  HomeLoggedIn({this.theme,this.user});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (context) => user,),
        ChangeNotifierProvider<AppTheme>(create: (context) => theme,)
      ],
      child: HomePage()
      
      );
  }
}



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return HomeDisplay();
  }
}

class HomeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _currentTheme = Provider.of<AppTheme>(context).currentTheme;
    return Scaffold(
        appBar: AppBar(
          title: Text("Todoist",
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(color: _currentTheme.font_color))),
          backgroundColor: _currentTheme.scaffold_color,
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0, top: 12.0, bottom: 10.0),
              child: GestureDetector(
                onTap: () {
                  // Provider.of<AppTheme>(context, listen: false)
                  //     .selectTheme('Normal');
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: ProfilePage()));
                },
                child: Hero(
                  tag: "Avatar",
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://i.pinimg.com/236x/6a/c4/5e/6ac45ea5a3f5ace324b79b8f36d30f27.jpg"),
                    radius: 22.0,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ListTags(
                    counter: 0,
                    icon: Icon(
                      Icons.today,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    text: "Today",
                    iconBackgroundColor: Colors.blue,
                  ),
                  ListTags(
                    counter: 0,
                    icon: Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    text: "Scheduled",
                    iconBackgroundColor: Colors.orange,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  ListTags(
                    counter: 0,
                    icon: Icon(
                      Icons.inbox,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    text: "All",
                    iconBackgroundColor: Colors.grey,
                  ),
                  ListTags(
                    counter: 0,
                    icon: Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    text: "Flagged",
                    iconBackgroundColor: Colors.red,
                  )
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  "My Lists",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: _currentTheme.font_color,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return MyLists(
                    count: 1,
                    icon: Icon(
                      Icons.format_list_bulleted,
                      color: Colors.white,
                    ),
                    listName: "Reminders",
                    iconBackgroundColor: Colors.orange,
                  );
                },
              ),
            ],
          ),
        ),
        backgroundColor: _currentTheme.scaffold_color,
      );
  }
}

class ListTags extends StatelessWidget {
  final int counter;
  final Icon icon;
  final text;
  final iconBackgroundColor;

  ListTags({this.counter, this.icon, this.text, this.iconBackgroundColor});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context).currentTheme;
    final _width = MediaQuery.of(context).size.width / 2 - 20.0;
    final _height = 100.0;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayListOfUser()));
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          color: theme.container_color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    child: this.icon,
                    backgroundColor: this.iconBackgroundColor,
                  ),
                  Text(
                    this.counter.toString(),
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            color: theme.font_color,
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0),
              alignment: AlignmentDirectional.topStart,
              child: Text(
                this.text,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyLists extends StatelessWidget {
  final listName;
  final count;
  final icon;
  final iconBackgroundColor;

  MyLists(
      {this.listName,
      this.count,
      this.icon,
      this.iconBackgroundColor,
     });

  @override
  Widget build(BuildContext context) {
        final theme = Provider.of<AppTheme>(context).currentTheme;

    final _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width,
      height: 60.0,
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12.0),
          color: theme.container_color),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 10.0,
              ),
              CircleAvatar(
                child: this.icon,
                backgroundColor: this.iconBackgroundColor,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                this.listName,
                style: GoogleFonts.roboto(
                    textStyle:
                        TextStyle(color: theme.font_color, fontSize: 20.0)),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                this.count.toString(),
                style: GoogleFonts.roboto(
                    textStyle:
                        TextStyle(color: theme.font_color, fontSize: 18.0)),
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                Icons.navigate_next,
                color: theme.font_color,
              )
            ],
          )
        ],
      ),
    );
  }
}
