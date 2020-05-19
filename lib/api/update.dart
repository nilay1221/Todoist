import 'dart:convert';

import 'package:dio/dio.dart';
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
 
}



class Update {

  Dio dio = new Dio();

}