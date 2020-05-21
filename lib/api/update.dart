import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/models/Models.dart';


class Api{

  Dio dio = new Dio();

  Api() {
  dio.options.headers['content-type'] = "application/json; charset=UTF-8";
  dio.options.headers['access-control-max-age'] = "3600" ;
  dio.options.headers['access-control-allow-headers'] = "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With";
  dio.options.headers['access-control-allow-origin'] = "http://localhost:80/auth_api/";
   }

  Future<bool> CreateUser(String username , String email,String password) async {
    

    Map data = {'username':username,'image':'img','email':email,'password':password};
    print(data);
    Response response = await dio.post("http://10.0.2.2:80/auth_api/api/create_user.php",data: data,options:Options(responseType:ResponseType.plain));
    print(response.data.toString());
    if(response.statusCode == 200) {
      String message = jsonDecode(response.data.toString())['message'] ;
      if(message == "User was created.") {
        return true;
      }
      else {
        return false;
      }
    }
  }

  Future<Map> loginUser(String email ,String password) async {
      Map data = {'email':email,'password':password}; 
      Response response = await dio.post('http://10.0.2.2:80/auth_api/api/login.php',data: data) ;
      // print(response.data);
      var parsedJson = response.data;
      // print(parsedJson);
      if(response.statusCode == 200) {
        if(parsedJson['message'] == 'Successful login.')
        return {'username':parsedJson['username'],'email': email,'token':parsedJson['jwt']};
      }
      else{
        return null;
      }
  }


  Future<String> updateUsername(String new_username,User user) async {
    Map data = {'username': new_username,'image':'image.png','email':user.email,'password':'','jwt':user.token};
    Response response = await dio.post('http://10.0.2.2:80/auth_api/api/update_user.php',data: data);
    if(response.statusCode == 200) {
      if(response.data['message'] == "User was updated."){
        return response.data['jwt'];
      }
    }

    return null;

  }

  Future<String> updateEmail(String new_email,User user) async {
    Map data = {'username':user.username,'image':'image.png','email':new_email,'password': '','jwt':user.token};
    Response response = await dio.post('http://10.0.2.2:80/auth_api/api/update_user.php',data: data);
    if(response.statusCode == 200) {
      if(response.data['message'] == "User was updated.") {
        return response.data['jwt'];
      }
    }
    return null;
  }

  Future<Map> dashboardDetails() async {

    Response response = await dio.post("http://10.0.2.2:80/auth_api/api/admin_stats.php");
    // print(response.statusCode);
    // print(response);
    if(response.statusCode == 200) {
      Map data = {
        "total_users" : response.data['allUsers'],
        "total_tasks" : response.data['allTasks'],
        "completed_tasks" :response.data['allCompletedTasks']

      };
      // print(data);
      return data;

    }
    else{
      return null;
    }

  }


  Future<int> getCompletedTasks() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
     Response response = await dio.post("http://10.0.2.2:80/auth_api/api/validate_token.php",data: {"jwt" : token});
    if(response.statusCode == 200) {
      String uid = response.data['data']['id'] ;
      DateTime today_date = DateTime.now();
       response = await dio.post("http://10.0.2.2:80/auth_api/api/user_stats.php",data: {"uid":uid.toString()});
      //  print(response.data['allTasksdata']);
      var task_data = response.data['completedTasksOfUser'];
      print(task_data);
      return task_data;
    }
    else{
      return null;
    }
    
  
  }

  Future<List> getGraphdetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    // String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9leGFtcGxlLm9yZyIsImF1ZCI6Imh0dHA6XC9cL2V4YW1wbGUuY29tIiwiaWF0IjoxMzU2OTk5NTI0LCJuYmYiOjEzNTcwMDAwMDAsImRhdGEiOnsiaWQiOiIyNCIsInVzZXJuYW1lIjoic21pdCBzaGFoIiwiaW1hZ2UiOiJpbWFnZS5wbmciLCJlbWFpbCI6InNtaXQxMjVAZ21haWwuY29tIn19.SgeSZVbS2lGfKwUwy2mQekeso8r04ZKLMZoI-ZLph0g";
    Response response = await dio.post("http://10.0.2.2:80/auth_api/api/validate_token.php",data: {"jwt" : token});
    if(response.statusCode == 200) {
      String uid = response.data['data']['id'] ;
      DateTime today_date = DateTime.now();
       response = await dio.post("http://10.0.2.2:80/auth_api/api/user_stats.php",data: {"uid":uid.toString()});
      //  print(response.data['allTasksdata']);
      var task_data = response.data['allTasksdata'];
      List<int> details = new List<int>.filled(7,0);
      task_data.forEach((element) {
        if(element['status'] == 1) {
          DateTime task_date = DateTime.parse(element['date_time']);
        int diff = today_date.difference(task_date).inDays ;
        // print(diff);
        if (diff <= 7) {
            details[diff] += 1;
          }
        }
        

      });
     return details;
    }
    else{
      return null;
    }
    
    
  }
 
}

