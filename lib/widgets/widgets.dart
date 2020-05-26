import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Container(
        width: 100.0,
        height: 60.0,
        child: Center(
          child: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                width: 20.0,
              ),
              Text("Please wait...")
            ],
          ),
        ),
      ),
    );

  }
}


class ErrorDialog extends StatelessWidget {

  final title;
  final content;

  ErrorDialog({this.title,this.content});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0)
    ),
    title: Text(title),
    content: Container(
      width: 100.0,
      height: 60.0,
      child: Center(
        child: Row(
          children: <Widget>[
            Icon(Icons.highlight_off,
            color: Colors.red,
            size: 40.0,),
            SizedBox(
              width: 10.0,
            ),
            Container(
              child: AutoSizeText(
                content,
                maxLines: 3,
              ),
            )
          ],
        ),
      ),
    ),
    actions: <Widget>[
      FlatButton(
        child: Text("OK"),
        onPressed: (){
        Navigator.pop(context);
        },
      )
    ],
  );
  }
}