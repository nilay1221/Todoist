import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoist/api/update.dart';
import 'package:todoist/pages/settings.dart';
import 'package:todoist/utils/theme.dart';
import 'dart:math' as math;



class DashboarLoading extends StatelessWidget {



  Future<Map> getDetails() async {
    Api api = Api();
    Map data = await api.dashboardDetails();
    print(data);
    int percent = 100 - (((data['total_tasks'] - data['completed_tasks']) ~/ data['total_tasks']) *100);
    data['percentage'] = percent;
    return data;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDetails(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          return Dashboard(data: snapshot.data,);
        }
        else{
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
      },
    );
  }
}

class Dashboard extends StatefulWidget {

  Map data;

  Dashboard({this.data});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getDetails();
  }

  

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _currentTheme = Provider.of<AppTheme>(context).currentTheme;

    return Scaffold(
      backgroundColor: _currentTheme.scaffold_color,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  CustomPaint(
                    size: Size((2 * _width), 300.0),
                    foregroundPainter: HeaderPainter(paint_color: _currentTheme.header_paint),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: () {Navigator.pop(context);}),
                        Text(
                          "Dashboard",
                          style: GoogleFonts.mPlusRounded1c(
                            textStyle: TextStyle(color: Colors.white),
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                          IconButton(
                            icon: Icon(Icons.settings, color: Colors.white),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 130.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: EdgeInsets.only(left: _width / 4 - 50.0),
                        child: Row(
                          children: <Widget>[
                            AdminTags(
                              icon: Icon(Icons.people,
                                  size: 30.0, color: Colors.blue),
                              count: widget.data['total_users'] ?? 0,
                              text: "Total Users",
                            ),
                            AdminTags(
                              icon: FaIcon(
                                FontAwesomeIcons.tasks,
                                size: 30.0,
                                color: Colors.orangeAccent,
                              ),
                              count: widget.data['total_tasks'] ?? 0,
                              text: "Tasks Created",
                            ),
                            AdminTags(
                              icon: FaIcon(
                                FontAwesomeIcons.check,
                                size: 30.0,
                                color: Colors.green,
                              ),
                              count: widget.data['completed_tasks'] ?? 0,
                              text: "Tasks Completed",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            CompletionRate(widget.data['percentage'] ?? 0),
          ],
        ),
      ),
    );
  }
}

class AdminTags extends StatelessWidget {
  final icon;
  final count;
  final text;

  AdminTags({this.icon, this.count, this.text});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 200.0,
        width: 200.0,
        margin: const EdgeInsets.only(
            bottom: 10.0, left: 20.0), //Same as `blurRadius` i guess
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.blue[800],
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              child: this.icon,
              radius: 30.0,
              backgroundColor: Color(0xFFe9f1f2),
            ),
            TweenAnimationBuilder(
                tween: IntTween(begin: 0, end: 20),
                duration: Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Text(
                    "$count",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 35.0,
                        textStyle: TextStyle(color: Colors.white)),
                  );
                }),
            Text("$text",
                style: GoogleFonts.sourceSansPro(
                    fontSize: 20.0, color: Colors.white))
          ],
        ),
      ),
    );
  }
}

class CompletionRate extends StatelessWidget {
  final percentage;
  CompletionRate(this.percentage);
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 250.0,
        width: 300.0,
        margin:
            const EdgeInsets.only(bottom: 10.0), //Same as `blurRadius` i guess
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.blue[800],
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10.0),
                child: Text("Completion Rate",
                    style: GoogleFonts.openSans(
                      fontSize: 25.0,
                      textStyle: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            CompletionRateBar(this.percentage)
          ],
        ),
      ),
    );
  }
}

class CompletionRateBar extends StatefulWidget {
  int percentage;

  CompletionRateBar(this.percentage);

  @override
  _CompletionRateBarState createState() => _CompletionRateBarState();
}

class _CompletionRateBarState extends State<CompletionRateBar>
    with SingleTickerProviderStateMixin<CompletionRateBar> {
  AnimationController _controller;
  double value = 0;
  double degree;
  int each_percentage = 0;
  final sweepAngle = (3 * math.pi) / 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    degree = (widget.percentage * sweepAngle) / 100.0;
    // print(degree);
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.addListener(() {
      _update();
    });
    _controller.forward();
  }

  void _update() {
    setState(() {
      value = _controller.value * this.degree;
      each_percentage = ((value * 100) ~/ sweepAngle).toInt();
      // print(value);
      // print(each_percentage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(
      child: Container(
        height: 150.0,
        width: 200.0,
        // color: Colors.blue,
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: Colors.blue
        //   ),
        //   // color:Colors.yellow
        // ),
      ),
      foregroundPainter: BarPainter(value, each_percentage),
    ));
  }
}

class BarPainter extends CustomPainter {
  double value;
  int counter;

  BarPainter(this.value, this.counter);

  @override
  void paint(Canvas canvas, Size size) {
    // Paint paint = new Paint()..color = Colors.black12..strokeCap = StrokeCap.round..style = PaintingStyle.stroke..strokeWidth = 10.0;
    Offset center = Offset(size.width / 2, size.height / 2);
    // canvas.drawCircle(center, 100.0, paint);
    //  final rect = Rect.fromCenter(center:center,width: 100.0,height: 100.0);
    final rect = Rect.fromLTRB(0, 10, 200, 190);
    final startAngle = (3 * math.pi / 4);
    final sweepAngle = (3 * math.pi) / 2;
    final useCenter = false;
    final paint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(colors: [Color(0xFF78ffd6), Color(0xFFa8ff78)])
          .createShader(rect);
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
    canvas.drawArc(rect, startAngle, this.value, useCenter, paint1);

    final textstyle = GoogleFonts.lato(
        textStyle: TextStyle(color: Colors.white), fontSize: 45.0);

    final textspan = TextSpan(text: '$counter%', style: textstyle);

    final textpainter =
        TextPainter(text: textspan, textDirection: TextDirection.ltr);

    textpainter.layout(minWidth: 0, maxWidth: size.width);

    final offset = Offset(size.width / 2 - 35.0, size.height / 2 - 10.0);

    textpainter.paint(canvas, offset);

    // canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(BarPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BarPainter oldDelegate) => false;
}

class HeaderPainter extends CustomPainter {

  Color paint_color;

  HeaderPainter({this.paint_color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(-100, -100.0, size.width + 100, 250);
    final paint = Paint()
      ..color = this.paint_color
      ..style = PaintingStyle.fill
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final startAngle = (0.0);
    final sweepAngle = 2 * (math.pi);
    final useCenter = false;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(HeaderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(HeaderPainter oldDelegate) => false;
}

// Color(0xFFe06a76)
