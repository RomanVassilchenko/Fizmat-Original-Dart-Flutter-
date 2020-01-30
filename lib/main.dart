import 'package:fizmatoriginal/Screen/MainScreen.dart';
import 'package:fizmatoriginal/Screen/ScheduleScreen.dart';
import 'package:fizmatoriginal/Screen/SettingsScreen.dart';
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
    MainScreen(),
    ScheduleScreen(
        url: "AKfycbxBsLHkxCKFYMgKPtNVXho_rNF4mWdX1vBSPLMpi-8EAB8VaqdO"),
    SettingsScreen(),
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
            "images/library.png",
            scale: 1.5,
          ),
          title: Text('Дополнительно'),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/schedule.png",
            scale: 1.5,
          ),
          title: Text('Расписание'),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "images/settings.png",
            scale: 1.5,
          ),
          title: Text('Настройки'),
        ),
      ],
    );
  }
}
