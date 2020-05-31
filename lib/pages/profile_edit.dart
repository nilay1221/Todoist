import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoist/api/update.dart';
import 'package:todoist/models/Models.dart';
import 'package:todoist/utils/theme.dart';
import 'package:todoist/widgets/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';


class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {


  Future<String> updateUsername(String new_username,User user) async {
      Api api = new Api();
      String new_token = await api.updateUsername(new_username, user);
      // print(new_token);
      return new_token;
  }


  Future<String> updateEmail(String new_email,User user) async {
      Api api = new Api();
      String new_token = await api.updateEmail(new_email, user);
      // print(new_token);
      if (new_token == "Email already exists.") {
        return null;
      }
      return new_token;
  }



  @override
  Widget build(BuildContext context) {
    final Mytheme theme = Provider.of<AppTheme>(context).currentTheme;
    final User user = Provider.of<User>(context);
    var pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return Scaffold(
      backgroundColor: theme.scaffold_color,
      appBar: AppBar(
        title: Text(
          "Profile Edit",
          style: TextStyle(color: theme.font_color),
        ),
        centerTitle: true,
        backgroundColor: theme.container_color,
        leading:IconButton(
          icon: Icon(Icons.arrow_back,color: theme.font_color,),
           onPressed: () {
             Navigator.pop(context);
             }
             )
             ),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () async {
                Map data = await showDialog(
                    context: context,
                    builder: (context) => ChangeDialog(
                          intialValue: "${user.username}",
                          title: "Change Name",
                        ));
                if(data['msg'] == "changed") {
                  // showDialog(context: context,
                  //           builder: (context) => LoadingDialog(),
                  //           barrierDismissible: false
                  //           );
                  await pr.show();
                  String new_username = data['new_value'];
                  String new_token = await updateUsername(new_username, user);
                  await Provider.of<User>(context,listen: false).updateUsername(new_username, new_token);
                  await pr.hide();
                  // print("dialog hidden");
                  // Navigator.pop(context);
                }
              },
              title: Text(
                "Name",
                style: TextStyle(color: theme.font_color),
              ),
              subtitle: Text(
                "${user.username}",
                style: TextStyle(color: theme.font_color),
              ),
            ),
            ListTile(
              onTap: () async {
                Map data = await showDialog(
                    context: context,
                    builder: (context) => ChangeDialog(
                          intialValue: "${user.email}",
                          title: "Change Email",
                        ));
                if(data['msg'] == "changed") {
                  await pr.show();
                  String new_email = data['new_value'];
                  String new_token = await updateEmail(new_email, user);
                  if(new_token != null ){
                    await Provider.of<User>(context,listen: false).updateEmail(new_email, new_token);
                    await pr.hide();
                  }
                  else{
                    await pr.hide();
                    showDialog(context: context,builder: (context) => ErrorDialog(title: "Update Error",content: "Email id already exists.\nPlease try again"));     
                  }
                  
                }
              },
              title: Text(
                'Email',
                style: TextStyle(color: theme.font_color),
              ),
              subtitle: Text(
                '${user.email}',
                style: TextStyle(color: theme.font_color),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChangeDialog extends StatelessWidget {
  final intialValue;
  final title;

  ChangeDialog({this.intialValue,this.title});

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController(text: this.intialValue);
    return AlertDialog(
      title: Text(
        this.title,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      content: Container(
        child: TextField(
          autofocus: true,
          controller: controller,
          style: TextStyle(color: Colors.white),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.purple),
          ),
          onPressed: () {
            Map data = {'msg': 'unchanged'};
            Navigator.pop(context,data);
          },
        ),
        FlatButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.purple),
          ),
          onPressed: () async {
            String newValue = controller.text.trim();
            if (newValue != intialValue) {
              Map data = {'msg':'changed','new_value':newValue};
              Navigator.pop(context,data);
            }
            else{
              Map data = {'msg':'unchanged'};
              Navigator.pop(context,data);
            }
          },
        )
      ],
    );
  }
}



