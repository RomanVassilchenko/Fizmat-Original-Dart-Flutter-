import 'dart:convert';

import 'package:fizmatoriginal/Model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

String apiKey = "AKfycbxBsLHkxCKFYMgKPtNVXho_rNF4mWdX1vBSPLMpi-8EAB8VaqdO";

List<String> classes = ["1A"],
    week = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"];
var _selectedIndex = 0;

Future<List<Schedule>> fetchScheduleBySource() async {
  var fetchedFile = await DefaultCacheManager()
      .getSingleFile('https://script.google.com/macros/s/$apiKey/exec');
  List schedules = json.decode(fetchedFile.readAsStringSync())['schedules'];
  return schedules.map((schedule) => new Schedule.fromJson(schedule)).toList();
}

Future<Null> fetchScheduleClass() async {
  var fetchedFile = await DefaultCacheManager().getSingleFile(
      'https://script.google.com/macros/s/AKfycbz7ofb88NYRa-hcsyJNkOof_r5vO3qpwBSPdgeLIqXtAAK41Dw/exec');
  classes = fetchedFile.readAsStringSync().split(" ");
}

class ScheduleScreen extends StatefulWidget {
  final String url;

  ScheduleScreen({Key key, @required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  var listSchedule;
  var dayOfWeek = 1;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    fetchScheduleClass();
    refreshListSchedule();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectIndexState(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Null> refreshListSchedule() async {
    refreshKey.currentState?.show(atTop: false);
    apiKey = widget.url;
    print(dayOfWeek);

    setState(() {
      listSchedule = fetchScheduleBySource();
    });
    return null;
  }

  void _selectIndexState(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Scaffold(
            appBar: AppBar(
                title: Center(
                  child: Row(
                    children: <Widget>[
                      CupertinoButton(
                          child: Text(
                            "Выбрать : ${classes[_selectedIndex]}",
                            style: TextStyle(color: Colors.white),
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
                                            classes.length, (int index) {
                                          return new Center(
                                            child: new Text(classes[index]),
                                          );
                                        })),
                                  );
                                });
                          }),
                    ],
                  ),
                ),
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                )),
            body: _scheduleBody()));
  }

  _scheduleBody() {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 9,
          child: Center(
            child: RefreshIndicator(
                key: refreshKey,
                child: FutureBuilder<List<Schedule>>(
                  future: listSchedule,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else if (snapshot.hasData) {
                      List<Schedule> schedules = snapshot.data;
                      List<Schedule> updatedSchedules;
                      schedules.removeWhere((item) =>
                      item.dayOfWeek.toString() != dayOfWeek.toString());
                      updatedSchedules =
                          schedules.map((element) => element).toList();
                      updatedSchedules.removeWhere((item) =>
                      item.classNumber.toString() !=
                          classes[_selectedIndex].toString());
                      updatedSchedules.removeWhere(
                              (item) => item.subjectTitle.toString() == "");
                      updatedSchedules.removeWhere(
                              (item) =>
                          item.time
                              .toString()
                              .length > 11);
                      updatedSchedules.removeWhere((item) =>
                      item.time.toString() == "" ||
                          item.time.toString() == null);
                      return (updatedSchedules.isEmpty)
                          ? Text(
                        (dayOfWeek == 6) ? "Свободный день" : "",
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
                                          borderRadius:
                                              BorderRadius.circular(0.0)),
                                      color: Color.fromRGBO(32, 33, 37, 1),
                                      elevation: 0.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                        "${schedule.time.substring(0, (schedule.time.length ~/ 2))}",
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                        "${schedule.time.substring(((schedule.time.length + 1) ~/ 2), schedule.time.length.toInt())}",
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                        ))),
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            top: 5.0),
                                                    child: Text(
                                                        "${schedule.classroom}",
                                                        style: TextStyle(
                                                            fontSize: 12.0)))
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
                                                      "${schedule
                                                          .subjectTitle}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
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
                onRefresh: refreshListSchedule),
          ),
        ),
        Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: new FlatButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    onPressed: () {
                      dayOfWeek--;
                      if (dayOfWeek == 0) dayOfWeek = 6;
                      refreshListSchedule();
                    },
                    child: new Text(
                      "<",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                new Text(
                  week[dayOfWeek - 1],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: new FlatButton(
                    onPressed: () {
                      dayOfWeek++;
                      if (dayOfWeek == 7) dayOfWeek = 1;
                      refreshListSchedule();
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      ">",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            )) // TODO Remove of fix this
      ],
    );
  }
}
