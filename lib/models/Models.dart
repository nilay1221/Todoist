import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier{
  String username ;
  String email ;
  String token ;
  String uid;

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
    preferences.setString('userType', 'user');
    preferences.setString('username', data['username']);
    preferences.setString('email', data['email']);
    preferences.setString('token', data['token']);
    preferences.setString('uid', data['uid']);
    this.username = data['username'];
    this.email =  data['email'];
    this.token = data['token'];
    this.uid = data['uid'];

    notifyListeners();
  }

  Future<void> saveAdmin(Map data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('userlogin', true);
    preferences.setString('userType', 'admin');
    preferences.setString('token', data['token']);
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

class TaskStats extends ChangeNotifier {

  int today_count;
  int all_count;
  int flagged_count;



  void getDetails(Map data) {
    this.today_count = data['today'];
    this.flagged_count = data['flagged'];
    this.all_count = data['all'];

  }

  void taskadd(Map task) {
    DateTime today_date = DateTime.now();
    DateTime task_date = DateTime.parse(task['date_time']);
    if(today_date.difference(task_date).inDays == 0) {
      
      this.today_count += 1;
    }
    this.all_count += 1;

    notifyListeners();
  }

  void taskDelete(Map task) {
    print("inside deleted task");
    this.all_count -= 1;
    // print(task);
    DateTime today_date = DateTime.now();
    DateTime task_date = DateTime.parse(task['date_time']);
    if(today_date.difference(task_date).inDays == 0) {
      this.today_count -= 1;
    }
    if(task['status'] == "1") {
      this.flagged_count -= 1;
      
    }

    notifyListeners();

  }

  void starTask(String status){
    print("inside star task");
    print(status);
    if(status == "1") {
      this.flagged_count += 1;
    }
    else if (status == "0") {
      this.flagged_count -= 1;
    }
    notifyListeners();
  }

}