import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoist/api/update.dart';
import 'package:todoist/app/admin/admin_home_page.dart';
import 'package:todoist/models/Models.dart';
import 'package:todoist/utils/theme.dart';
import 'package:todoist/widgets/widgets.dart';
import 'package:todoist/pages/home.dart';


class LoginPage extends StatefulWidget {
  LoginPage({@required this.toggleFormType});
  final Function toggleFormType;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email;

  String _password;

  String _username;

  bool adminLogin = false;

  String loginType = "Admin Login?" ;



  bool _checkFormStatus() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void AdminLoginToggle() {
    setState(() {
      if(adminLogin){
        adminLogin =false;
        this.loginType = "Admin Login?";
      } 
      else {
        adminLogin = true;
        this.loginType = "User Login?";
      }
    });
  }



void onLoginSubmit() async {
     Api api = new Api();
  showDialog(context: context,
    builder: (context) => LoadingDialog(),
    barrierDismissible: false
    );
    try{
      if(adminLogin == false)
      {
        var response = await  api.loginUser(_email, _password);
      print(response);
      if(response != null && response['username'] != "blocked") {
        // User user = response;
        await Provider.of<User>(context,listen: false).saveUser(response);
          await Provider.of<AppTheme>(context,listen: false).selectTheme(true);
          var task_details = await api.getTaskdetails(response['uid']);
          print(task_details);
          await Provider.of<TaskStats>(context,listen: false).getDetails(task_details);
        Navigator.pop(context);
        showDialog(context: context,
            builder: (context) => SuccessDialog(),
            barrierDismissible: false,
          );

      }
      else if ( response!= null && response['username'] == "blocked" )
       {
         Navigator.pop(context);
        showDialog(context: context,
        builder: (context) => ErrorDialog(title:'Blocked',content: 'You were blocked \n by your admin.',),
        barrierDismissible: false
      );
       }
      else{
        throw Exception();
      }
        
      }
      if(adminLogin) {

        var response = await api.adminLogin(_username, _password);
        if(response!=null) {
             Provider.of<User>(context,listen: false).saveAdmin(response);
              await Provider.of<AppTheme>(context,listen: false).selectTheme(true);
              Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHomePage()));

        }

      }
      
    }
    catch(e) {
        print(e);
      Navigator.pop(context);
      showDialog(context: context,
      builder: (context) => ErrorDialog(title:'Fail',content: 'Login failed!..',),
      barrierDismissible: false
      );
  }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: NetworkImage(
              'https://coloredbrain.com/wp-content/uploads/2016/07/login-background.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 150,
                    child: Image.network(
                        'https://i0.wp.com/codecollege.co.za/wp-content/uploads/2016/12/kisspng-dart-programming-language-flutter-object-oriented-flutter-logo-5b454ed3d65b91.767530171531268819878.png?fit=550%2C424&ssl=1'),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: Text(
                      'Todoist',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                 adminLogin ?_usernameInputField() : _emailInputField(),
                  SizedBox(height: 10.0),
                  _passwordInputField(),
                  SizedBox(height: 10.0),
                  SizedBox(
                    height: 50.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          side: BorderSide(color: Colors.white)),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      textColor: Colors.white,
                      child: Text('Login'),
                      onPressed: ()  async{
                        if(_checkFormStatus()){
                         onLoginSubmit();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      // side: BorderSide(color: Colors.white)),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      textColor: Colors.white,
                      child: Text('Don\'t have an Account? Sign Up'),
                      onPressed: widget.toggleFormType,
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      // side: BorderSide(color: Colors.white)),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      textColor: Colors.white,
                      child: Text(loginType),
                      onPressed: () => AdminLoginToggle(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailInputField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      onSaved: (value) => _email = value,
      validator: (String value) {
         Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
         RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
            return 'Enter Valid Email';
        else
          return null;},
      textInputAction: TextInputAction.none,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          // hintText: 'Enter your product title',
          labelStyle: TextStyle(color: Colors.white),
          labelText: 'Email Address'),
    );
  }

  Widget _passwordInputField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      onSaved: (value) => _password = value,
      textInputAction: TextInputAction.none,
      obscureText: true,
      decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelStyle: TextStyle(color: Colors.white),
          labelText: 'Password'),
    );
  }


  Widget _usernameInputField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      onSaved: (value) => _username = value,
      validator: (String value ) {
        if(value.length ==0) {
          return 'Please enter username';
        }
        else if(value.length < 3) {
          return "Username should have min 3 characters";
        }
        else return null;
      },
      textInputAction: TextInputAction.none,
      decoration: InputDecoration(
          hasFloatingPlaceholder: true,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelStyle: TextStyle(color: Colors.white),
          labelText: 'Admin Username'),
    );
  }







}



  



class SuccessDialog extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Login"
      ),
      content: Container(
        width: 100.0,
        height: 60.0,
        child: Column(
          children: <Widget>[
            AutoSizeText(
                "You have been logged in Sucessfully",
                maxLines: 2,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: (){
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeDisplay()));
          },
        )
      ],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    );
  }
}


