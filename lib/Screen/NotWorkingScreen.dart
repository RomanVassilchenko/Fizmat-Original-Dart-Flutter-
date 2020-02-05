import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool townSwitcher = false;

class NotWorkingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotWorkingScreenState();
}

class NotWorkingScreenState extends State<NotWorkingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text("В разработке"),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "На данный момент эта функция находится в разработке. Спасибо за понимание.",
                  textAlign: TextAlign.center,
                ),
              ),
            )));
  }
}
