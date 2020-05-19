import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier{
  String username ;
  String email ;
  String token ;

  // User(this.username,this.email,this.token);

  Future<void> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user =preferences.getString('username') ?? '';
    String email = preferences.getString('email') ?? '';
    String token = preferences.getString('token') ?? '' ;
    this.username = user;
    this.email = email;
    this.token = token;
    print(username);

    notifyListeners();
  }

   Future<void> saveUser(Map data) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('userlogin', true);
    preferences.setString('username', data['username']);
    preferences.setString('email', data['email']);
    preferences.setString('token', data['token']);
    this.username = data['username'];
    this.email =  data['email'];
    this.token = data['token'];

    notifyListeners();
  }

  Future<void> updateUsername(String new_username,String new_token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', new_token);
    preferences.setString('username', new_username);
    this.username = new_username;
    this.token = new_token;

    notifyListeners();
  }

  Future<void> updateEmail(String new_email,String new_token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', new_token);
    preferences.setString('email', new_email);
    this.email = new_email;
    this.token = new_token;

    notifyListeners();
  }

  Future<void> logoutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('userlogin', false);
    preferences.setString('username', '');
    preferences.setString('email', '');
    preferences.setString('token', '');

    
  }

  }

class UserDisplayDetails extends ChangeNotifier{

  User user ;

  UserDisplayDetails({this.user});

  void updateDetails() {
    notifyListeners();
    }

}