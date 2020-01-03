import 'package:fizmatoriginal/Screen/ArticleScreen.dart';
import 'package:fizmatoriginal/Screen/ScheduleScreen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Главная",
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Scaffold(
            body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Builder(
              builder: (context) => Center(
                child: FloatingActionButton.extended(
                  heroTag: "news",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ArticleScreen(
                            url:
                                "AKfycbzkpgPRlnZ18dMC8WlxSeSrlwNIwAo0nwAEr29XYbJHvbQFNMY",
                            title: "Новости")));
                  },
                  icon: Icon(Icons.new_releases),
                  label: Text("Новости"),
                ),
              ),
            ),
            Builder(
              builder: (context) => Center(
                child: FloatingActionButton.extended(
                  heroTag: "schedule",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScheduleScreen(
                            url:
                                "AKfycbxBsLHkxCKFYMgKPtNVXho_rNF4mWdX1vBSPLMpi-8EAB8VaqdO")));
                  },
                  icon: Icon(Icons.schedule),
                  label: Text("Расписание"),
                ),
              ),
            ),
          ],
        )));
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
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
