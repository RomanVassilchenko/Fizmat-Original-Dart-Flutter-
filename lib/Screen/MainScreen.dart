import 'dart:convert';

import 'package:fizmatoriginal/Model/model.dart';
import 'package:fizmatoriginal/Screen/ArticleScreen.dart';
import 'package:fizmatoriginal/Screen/ScheduleScreen.dart';
import 'package:fizmatoriginal/Screen/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<List<Source>> fetchNewsSource() async {
  var fetchedFile = await DefaultCacheManager().getSingleFile(
      'https://script.google.com/macros/s/AKfycbwuDdll6PANdIwEXqoTilUW1N3w4DFx70CPEBgIe4EF1hUFUIwN/exec');
  List sources = json.decode(fetchedFile.readAsStringSync())['sources'];
  return sources.map((source) => new Source.fromJson(source)).toList();
}

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  var listSources;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshListSource();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Новости",
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Scaffold(
          appBar: _appBar(),
          body: _body(),
        ));
  }

  _appBar() {
    return AppBar(
        title: Center(
          child: Text(
            "Главная",
            style: TextStyle(fontSize: 25.0),
          ),
        ));
  }

  _body() {
    return Center(
      child: RefreshIndicator(
        child: FutureBuilder<List<Source>>(
          future: listSources,
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
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ArticleScreen(
                                            url:
                                            "AKfycbzkpgPRlnZ18dMC8WlxSeSrlwNIwAo0nwAEr29XYbJHvbQFNMY",
                                            title: "Новости")));
                              }
                              break;
                            case "schedule":
                              {
                                Navigator.of(context).push(MaterialPageRoute(
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
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SettingsScreen()));
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Image.asset(
                                  source.url,
                                  scale: 10.0,
                                  color: Colors.white,
                                ),
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
    );
  }

  Future<Null> refreshListSource() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      listSources = fetchNewsSource();
    });
    return null;
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
//  _launchUrl(String url) async {
//    if (await canLaunch(url)) {
//      await launch(url, forceWebView: true);
//    } else {
//      throw ('Couldn\'t launch $url ');
//    }
//  }
}
