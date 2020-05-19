import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mytheme {
  Color scaffold_color;
  Color font_color;
  Color container_color;

  Mytheme({this.scaffold_color, this.font_color, this.container_color});
}





class AppTheme extends ChangeNotifier {
  Map<String, Mytheme> themes = {
    "Dark": Mytheme(
        scaffold_color: Colors.black,
        font_color: Colors.white,
        container_color: Colors.grey[900]),
    "Light": Mytheme(
        scaffold_color: Colors.grey[300],
        font_color: Colors.black,
        container_color: Colors.white)
  };

  Mytheme currentTheme ;
  bool themeSelected ;

  // AppTheme(bool isLight)  {
  //  getCurrentTheme(isLight);
  // }




  Future<void> selectTheme(bool isLight) async {
      if(isLight){
           this.currentTheme =  themes['Light'];
           this.themeSelected = true;
      }
      else{
        this.currentTheme = themes['Dark'];
        this.themeSelected = false;
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('isLight', isLight);
     
      
      notifyListeners();
  }

  void getCurrentTheme(bool isLight) async {
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // bool isLight = preferences.getBool('isLight') ?? false;
  print(isLight);
  if(isLight) {
    this.currentTheme = themes['Light'];
    this.themeSelected = true;
  }
  else{
    this.currentTheme = themes['Dark'];
    this.themeSelected = false;
  }
}
}


// class MyInheritedWidget extends InheritedWidget{

//   final Mytheme theme;

//   MyInheritedWidget({Widget child,this.theme}) : super(child:child);

//   @override
//   bool updateShouldNotify(MyInheritedWidget oldWidget) {
//     // TODO: implement updateShouldNotify
//     theme != oldWidget.theme;
//   }

//   static MyInheritedWidget of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
//   } 

// }