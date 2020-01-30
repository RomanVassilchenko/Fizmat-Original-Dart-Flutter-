import 'dart:convert';

import 'package:fizmatoriginal/Model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

String apiKey = "AKfycbxBsLHkxCKFYMgKPtNVXho_rNF4mWdX1vBSPLMpi-8EAB8VaqdO";
List<String> week = [
  "Понедельник",
  "Вторник",
  "Среда",
  "Четверг",
  "Пятница",
  "Суббота"
];
List<String> classList = ["1A", "1D"];
var scheduleList;

addIntToSF(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

getIntValuesSF(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int intValue = prefs.getInt(key) ?? 0;
  return intValue;
}

Future<List<Schedule>> fetchScheduleList() async {
  var fetchedFile = await DefaultCacheManager()
      .getSingleFile('https://script.google.com/macros/s/$apiKey/exec');
  List schedules = json.decode(fetchedFile.readAsStringSync())['schedules'];
  return schedules.map((schedule) => new Schedule.fromJson(schedule)).toList();
}

Future<Null> fetchClassList() async {
  var fetchedFile = await DefaultCacheManager().getSingleFile(
      'https://script.google.com/macros/s/AKfycbz7ofb88NYRa-hcsyJNkOof_r5vO3qpwBSPdgeLIqXtAAK41Dw/exec');
  classList = fetchedFile.readAsStringSync().split(" ");
}

class ScheduleScreen extends StatefulWidget {
  final String url;

  ScheduleScreen({Key key, @required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var _dayOfWeek = 1,
      _scheduleClassIndex = 0;

  Future<Null> initSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var schedule = prefs.getInt("classSelectedIndex") ?? 0;
    var day = prefs.getInt("daySelectedIndex") ?? 1;
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _scheduleClassIndex = schedule;
        _dayOfWeek = day;
      });
      refreshListSchedule();
    });
  }

  void _selectIndexState(int index) {
    setState(() {
      _scheduleClassIndex = index;
    });
    addIntToSF("classSelectedIndex", index);
  }

  void _selectDayState(int index) {
    setState(() {
      _dayOfWeek = index + 1;
      refreshListSchedule();
    });
    addIntToSF("daySelectedIndex", index + 1);
  }

  Future<Null> refreshListSchedule() async {
    refreshKey.currentState?.show(atTop: false);
    apiKey = widget.url;
    setState(() {
      scheduleList = fetchScheduleList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchClassList();
    refreshListSchedule();
    initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
                child: Text(
                  "Выбрать : ${classList[_scheduleClassIndex]}",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 225.0,
                          child: CupertinoPicker(
                              itemExtent: 32.0,
                              onSelectedItemChanged: (int index) {
                                _selectIndexState(index);
                              },
                              children: new List<Widget>.generate(
                                  classList.length, (int index) {
                                return new Center(
                                  child: new Text(classList[index]),
                                );
                              })),
                        );
                      });
                }),
            CupertinoButton(
                child: Text(
                  "Выбрать : ${week[_dayOfWeek - 1]}",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 225.0,
                          child: CupertinoPicker(
                              itemExtent: 32.0,
                              onSelectedItemChanged: (int index) {
                                _selectDayState(index);
                              },
                              children: new List<Widget>.generate(week.length,
                                      (int index) {
                                    return new Center(
                                      child: new Text(week[index]),
                                    );
                                  })),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }

  _body() {
    return Center(
      child: RefreshIndicator(
        key: refreshKey,
        child: FutureBuilder<List<Schedule>>(
          future: scheduleList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Schedule> schedules = snapshot.data;
              List<Schedule> updatedSchedules;
              schedules.removeWhere(
                      (item) =>
                  item.dayOfWeek.toString() != _dayOfWeek.toString());
              updatedSchedules = schedules.map((element) => element).toList();
              updatedSchedules.removeWhere((item) =>
              item.classNumber.toString() !=
                  classList[_scheduleClassIndex].toString());
              updatedSchedules
                  .removeWhere((item) => item.subjectTitle.toString() == "");
              updatedSchedules
                  .removeWhere((item) =>
              item.time
                  .toString()
                  .length > 11);
              updatedSchedules.removeWhere((item) =>
              item.time.toString() == "" || item.time.toString() == null);
              return (updatedSchedules.isEmpty)
                  ? Text(
                (_dayOfWeek == 6) ? "Свободный день" : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              )
                  : ListView(
                children: updatedSchedules
                    .map(
                      (schedule) =>
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0)),
                        color: Color.fromRGBO(32, 33, 37, 1),
                        elevation: 0.0,
                        margin: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 8.0),
                                      child: Text(
                                          "${schedule.time.substring(
                                              0, (schedule.time.length ~/ 2))}",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight:
                                              FontWeight.bold))),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 8.0),
                                      child: Text(
                                          "${schedule.time.substring(
                                              ((schedule.time.length + 1) ~/ 2),
                                              schedule.time.length.toInt())}",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ))),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 8.0, top: 5.0),
                                      child: Text("${schedule.classroom}",
                                          style:
                                          TextStyle(fontSize: 12.0)))
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 25.0,
                                        bottom: 25.0),
                                    child: Text(
                                        "${schedule.subjectTitle}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                )
                    .toList(),
              );
            }
            return CircularProgressIndicator();
          },
        ),
        onRefresh: refreshListSchedule,
      ),
    );
  }
}
