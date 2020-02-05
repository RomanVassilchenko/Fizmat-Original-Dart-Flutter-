import 'package:fizmatoriginal/Screen/MainScreen.dart';
import 'package:fizmatoriginal/Screen/NotWorkingScreen.dart';
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
    NotWorkingScreen(),
    ScheduleScreen(
        url: "AKfycbxBsLHkxCKFYMgKPtNVXho_rNF4mWdX1vBSPLMpi-8EAB8VaqdO"),
    NotWorkingScreen(),
    MainScreen(),
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
            "images/marks.png",
            scale: 17.0,
            color: Colors.white,
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Оценки'),
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
            "images/more.png",
            scale: 17.0,
            color: Colors.white,
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Дополнительно'),
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
