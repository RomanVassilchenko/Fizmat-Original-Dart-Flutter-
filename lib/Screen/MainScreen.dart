import 'dart:convert';

import 'package:fizmatoriginal/Model/model.dart';
import 'package:fizmatoriginal/Screen/ArticleScreen.dart';
import 'package:fizmatoriginal/Screen/ScheduleScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<List<Source>> fetchNewsSource() async {
  final response = await http.get(
      'https://script.google.com/macros/s/AKfycbwuDdll6PANdIwEXqoTilUW1N3w4DFx70CPEBgIe4EF1hUFUIwN/exec');
  if (response.statusCode == 200) {
    List sources = json.decode(response.body)['sources'];
    return sources.map((source) => new Source.fromJson(source)).toList();
  } else {
    throw Exception("Failed to load source list");
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  var list_sources;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshListSource();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Новости",
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Scaffold(
          appBar: AppBar(
              title: Center(
                child: Text(
                  "Главная",
                  style: TextStyle(fontSize: 25.0),
                ),
              )),
          body: Center(
            child: RefreshIndicator(
              child: FutureBuilder<List<Source>>(
                future: list_sources,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error:${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<Source> sources = snapshot.data;
                    sources.sort((a, b) => b.flag.compareTo(a.flag));
                    return new ListView(
                        children: sources
                            .map((source) =>
                            GestureDetector(
                              onTap: () {
                                switch (source.id) {
                                  case "news":
                                    {
                                      Navigator.of(
                                          context)
                                          .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ArticleScreen(
                                                  url:
                                                  "AKfycbzkpgPRlnZ18dMC8WlxSeSrlwNIwAo0nwAEr29XYbJHvbQFNMY",
                                                  title: "Новости")));
                                    }
                                    break;
                                  case "schedule":
                                    {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScheduleScreen(
                                                      url:
                                                      "AKfycbxBsLHkxCKFYMgKPtNVXho_rNF4mWdX1vBSPLMpi-8EAB8VaqdO")));
                                    }
                                    break;
                                  case "library":
                                    {
                                      _showToast(context);
                                    }
                                    break;
                                  case "marks":
                                    {
                                      _showToast(context);
                                    }
                                    break;

                                  case "notes":
                                    {
                                      _showToast(context);
                                    }
                                    break;
                                  case "homework":
                                    {
                                      _showToast(context);
                                    }
                                    break;
                                  case "chat":
                                    {
                                      _showToast(context);
                                    }
                                    break;
                                  case "helpdesk":
                                    {
                                      _showToast(context);
                                    }
                                    break;
                                  case "settings":
                                    {
                                      _showToast(context);
                                    }
                                    break;
                                  default:
                                    {
                                      _showToast(context);
                                    }
                                    break;
                                }
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                elevation: 1.0,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 13.0),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: new AssetImage(source.url),
                                        ),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      width: 128.0,
                                      height: 115.0,
                                      child: (source.flag == "F")
                                          ? Image.asset("images/lock.png")
                                          : null,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 46.0, bottom: 10.0),
                                      child: Text(
                                        '${source.name}',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                            .toList());
                  }
                  return CircularProgressIndicator();
                },
              ),
              key: refreshKey,
              onRefresh: refreshListSource,
            ),
          ),
        ));
  }

  Future<Null> refreshListSource() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_sources = fetchNewsSource();
    });
    return null;
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ('Couldn\'t launch ${url} ');
    }
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Находится в разработке'),
        action: SnackBarAction(
            label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}

//import 'package:fizmatoriginal/Screen/ArticleScreen.dart';
//import 'package:fizmatoriginal/Screen/ScheduleScreen.dart';
//import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';
//
//class MainScreen extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() => MainScreenState();
//}
//
//class MainScreenState extends State<MainScreen> {
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//        title: "Главная",
//        theme: ThemeData(
//          brightness: Brightness.light,
//          primaryColor: Colors.red,
//        ),
//        darkTheme: ThemeData(
//          brightness: Brightness.dark,
//        ),
//        home: Scaffold(
//            body: Center(
//          child: Wrap(
//            alignment: WrapAlignment.spaceAround,
//            crossAxisAlignment: WrapCrossAlignment.center,
//            direction: Axis.vertical,
//            children: <Widget>[
//              Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Builder(
//                    builder: (context) => Center(
//                      child: ClipOval(
//                        child: Material(
//                          color: Colors.blue, // button color
//                          child: InkWell(
//                            splashColor: Colors.red, // inkwell color
//                            child: SizedBox(
//                                width: 72,
//                                height: 72,
//                                child: Image.network(
//                                  "https://firebasestorage.googleapis.com/v0/b/fizmat-original.appspot.com/o/news.png?alt=media&token=ed6fec71-0246-43ef-8275-d9c334d8f8f4",
//                                  scale: 1.5,
//                                )),
//                            onTap: () {
//                              Navigator.of(context).push(MaterialPageRoute(
//                                  builder: (context) => ArticleScreen(
//                                      url:
//                                          "AKfycbzkpgPRlnZ18dMC8WlxSeSrlwNIwAo0nwAEr29XYbJHvbQFNMY",
//                                      title: "Новости")));
//                            },
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(10.0),
//                    child: Text("Новости"),
//                  ),
//                ],
//              ),
//              Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Builder(
//                    builder: (context) => Center(
//                      child: ClipOval(
//                        child: Material(
//                          color: Colors.blue, // button color
//                          child: InkWell(
//                              splashColor: Colors.red, // inkwell color
//                              child: SizedBox(
//                                  width: 72,
//                                  height: 72,
//                                  child: Image.network(
//                                    "https://firebasestorage.googleapis.com/v0/b/fizmat-original.appspot.com/o/schedule.png?alt=media&token=affc44f1-2f6b-4a2e-a584-aad906bd6481",
//                                    scale: 1.5,
//                                  )),
//                              onTap: () {
//                                Navigator.of(context).push(MaterialPageRoute(
//                                    builder: (context) => ScheduleScreen(
//                                        url:
//                                            "AKfycbxBsLHkxCKFYMgKPtNVXho_rNF4mWdX1vBSPLMpi-8EAB8VaqdO")));
//                              }),
//                        ),
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(10.0),
//                    child: Text("Расписание"),
//                  ),
//                ],
//              ),
//              Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Builder(
//                    builder: (context) => Center(
//                      child: ClipOval(
//                        child: Material(
//                          color: Colors.blue, // button color
//                          child: InkWell(
//                            splashColor: Colors.red, // inkwell color
//                            child: SizedBox(
//                                width: 72,
//                                height: 72,
//                                child: Image.network(
//                                  "https://firebasestorage.googleapis.com/v0/b/fizmat-original.appspot.com/o/noted.png?alt=media&token=64d7b3b4-3fa8-4987-a936-34fefc28cce0",
//                                  scale: 1.5,
//                                )),
//                            onTap: () {},
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(10.0),
//                    child: Text("Статьи"),
//                  ),
//                ],
//              ),
//              Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Builder(
//                    builder: (context) => Center(
//                      child: ClipOval(
//                        child: Material(
//                          color: Colors.blue, // button color
//                          child: InkWell(
//                            splashColor: Colors.red, // inkwell color
//                            child: SizedBox(
//                                width: 72,
//                                height: 72,
//                                child: Image.network(
//                                  "https://firebasestorage.googleapis.com/v0/b/fizmat-original.appspot.com/o/settings.png?alt=media&token=283000ba-0a7f-49dc-b9a0-0ae4844494e0",
//                                  scale: 1.5,
//                                )),
//                            onTap: () {},
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(10.0),
//                    child: Text("Настройки"),
//                  ),
//                ],
//              ),
//            ],
//          ),
//        )));
//  }
//
//  _launchUrl(String url) async {
//    if (await canLaunch(url)) {
//      await launch(url, forceWebView: true);
//    } else {
//      throw ('Couldn\'t launch ${url} ');
//    }
//  }
//
//  void _showToast(BuildContext context) {
//    final scaffold = Scaffold.of(context);
//    scaffold.showSnackBar(
//      SnackBar(
//        content: const Text('Находится в разработке'),
//        action: SnackBarAction(
//            label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
//      ),
//    );
//  }
//}
