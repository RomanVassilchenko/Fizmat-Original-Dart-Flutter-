import 'package:fizmatoriginal/Screen/ArticleScreen.dart';
import 'package:fizmatoriginal/Screen/HelpScreen.dart';
import 'package:fizmatoriginal/Screen/NotesScreen.dart';
import 'package:fizmatoriginal/Screen/ScheduleScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedTab = 1;
  final _pageOptions = [
    ArticleScreen(
        url: "AKfycbzkpgPRlnZ18dMC8WlxSeSrlwNIwAo0nwAEr29XYbJHvbQFNMY",
        title: "Новости"),
    ScheduleScreen(
        url: "AKfycbxBsLHkxCKFYMgKPtNVXho_rNF4mWdX1vBSPLMpi-8EAB8VaqdO"),
    NotesScreen(),
    HelpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        body: _pageOptions[_selectedTab],
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTab,
      onTap: (int index) {
        setState(() {
          _selectedTab = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/news.png",
            scale: 17.0,
            color: Colors.white,
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Новости'),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/schedule.png",
            scale: 17.0,
            color: Colors.white,
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Расписание'),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/notes.png",
            scale: 17.0,
            color: Colors.white,
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Статьи'),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/helpdesk.png",
            scale: 17.0,
            color: Colors.white,
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Help Desk'),
          ),
        ),
      ],
    );
  }
}

/*
* Image.asset(
            "images/settings.png",
            color: Colors.white,
            scale: 1.5,
          ),
* */
