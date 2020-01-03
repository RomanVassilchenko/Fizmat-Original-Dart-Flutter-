import 'dart:convert';

import 'package:fizmatoriginal/Model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

String API_KEY = "AKfycbxBsLHkxCKFYMgKPtNVXho_rNF4mWdX1vBSPLMpi-8EAB8VaqdO";
http.Response responseSchedule;
http.Response responseClass;

Future<List<Schedule>> fetchScheduleBySource() async {
  if (responseSchedule == null) {
    responseSchedule =
        await http.get('https://script.google.com/macros/s/${API_KEY}/exec');
  }
  if (responseSchedule.statusCode == 200) {
    List schedules = json.decode(responseSchedule.body)['schedules'];
    return schedules
        .map((schedule) => new Schedule.fromJson(schedule))
        .toList();
  } else {
    throw Exception("Failed to load schedule list");
  }
}

void fetchScheduleClass() async {
  if (responseClass == null) {
    responseClass = await http.get(
        'https://script.google.com/macros/s/AKfycbz7ofb88NYRa-hcsyJNkOof_r5vO3qpwBSPdgeLIqXtAAK41Dw/exec');
  }
  if (responseClass.statusCode == 200) {
    classes = responseClass.body.split(" ");
    return;
  } else {
    throw Exception("Failed to load schedule list");
  }
}

List<String> classes = const <String>['10X'];

int _selectedIndex = 0;

class ScheduleScreen extends StatefulWidget {
  final String url;

  ScheduleScreen({Key key, @required this.url});

  @override
  State<StatefulWidget> createState() => ScheduleScreenState(url: url);
}

class ScheduleScreenState extends State<ScheduleScreen> {
  final String url;

  ScheduleScreenState({Key key, @required this.url});

  void selectIndexState(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            bottom: TabBar(
              tabs: [
                Text("ПН", style: TextStyle(fontSize: 14)),
                Text("ВТ", style: TextStyle(fontSize: 14)),
                Text("СР", style: TextStyle(fontSize: 14)),
                Text("ЧТ", style: TextStyle(fontSize: 14)),
                Text("ПТ", style: TextStyle(fontSize: 14)),
                Text("СБ", style: TextStyle(fontSize: 14)),
              ],
            ),
            title: Row(
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
                              height: 200.0,
                              child: CupertinoPicker(
                                  itemExtent: 32.0,
                                  onSelectedItemChanged: (int index) {
                                    selectIndexState(index);
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
          body: TabBarView(
            children: [
              ScheduleScreenPage(url: url, dayOfWeek: 1),
              ScheduleScreenPage(url: url, dayOfWeek: 2),
              ScheduleScreenPage(url: url, dayOfWeek: 3),
              ScheduleScreenPage(url: url, dayOfWeek: 4),
              ScheduleScreenPage(url: url, dayOfWeek: 5),
              ScheduleScreenPage(url: url, dayOfWeek: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleScreenPage extends StatefulWidget {
  final String url;
  final int dayOfWeek;

  ScheduleScreenPage({Key key, @required this.url, this.dayOfWeek})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ScheduleScreenPageState();
}

class ScheduleScreenPageState extends State<ScheduleScreenPage> {
  var list_schedule;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    refreshListSchedule();
    fetchScheduleClass();
  }

  Future<Null> refreshListSchedule() async {
    refreshKey.currentState?.show(atTop: false);
    API_KEY = widget.url;
    print(widget.dayOfWeek);

    setState(() {
      list_schedule = fetchScheduleBySource();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
            key: refreshKey,
            child: FutureBuilder<List<Schedule>>(
              future: list_schedule,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Schedule> schedules = snapshot.data;
                  List<Schedule> updatedSchedules;
                  schedules.removeWhere((item) =>
                      item.dayOfWeek.toString() != widget.dayOfWeek.toString());
                  updatedSchedules =
                      schedules.map((element) => element).toList();
                  updatedSchedules.removeWhere((item) =>
                      item.class_number.toString() !=
                      classes[_selectedIndex].toString());
                  updatedSchedules.removeWhere(
                      (item) => item.subject_title.toString() == "");
                  updatedSchedules
                      .removeWhere((item) => item.time.toString().length > 11);
                  updatedSchedules.removeWhere((item) =>
                      item.time.toString() == "" ||
                      item.time.toString() == null);
                  return (updatedSchedules.isEmpty)
                      ? Text(
                          "Свободный день",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        )
                      : ListView(
                          children: updatedSchedules
                              .map((schedule) => GestureDetector(
                                    onTap: () {
                                      //TODO Think what can we add here
                                    },
                                    child: Card(
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
                                                      "${schedule.subject_title}",
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
                                  ))
                              .toList(),
                        );
                }
                return CircularProgressIndicator();
              },
            ),
            onRefresh: refreshListSchedule),
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ('Couldn\'t launch ${url} ');
    }
  }
}
