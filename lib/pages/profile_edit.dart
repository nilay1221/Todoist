import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoist/utils/theme.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  @override
  Widget build(BuildContext context) {

    final Mytheme theme = Provider.of<AppTheme>(context).currentTheme;
    return Scaffold(
      backgroundColor: theme.scaffold_color,
      appBar: AppBar(
          title: Text("Profile Edit",
          style: TextStyle(color: theme.font_color),
          ),
          centerTitle: true,
          backgroundColor: theme.container_color,
          leading: Icon(Icons.arrow_back,color: theme.font_color,),),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                "Avatar",
                style: TextStyle(color:theme.font_color),
              ),
              trailing: Hero(
                tag: "Avatar",
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://i.pinimg.com/236x/6a/c4/5e/6ac45ea5a3f5ace324b79b8f36d30f27.jpg"),
                  radius: 20.0,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => NameChangeDialog(
                          intialName: "Nilay",
                        ));
              },
              title: Text(
                "Name",
                style: TextStyle(color: theme.font_color),),
              subtitle: Text(
                "Nilay",
                style: TextStyle(
                  color: theme.font_color
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                'Email',
                style: TextStyle(color: theme.font_color),
              ),
              subtitle: Text(
                'test@xyz.com',
                style: TextStyle(color: theme.font_color),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NameChangeDialog extends StatelessWidget {
  final intialName;

  NameChangeDialog({this.intialName});

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController(text: this.intialName);
    return AlertDialog(
      title: Text(
        "Change Name",
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
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.purple),
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
