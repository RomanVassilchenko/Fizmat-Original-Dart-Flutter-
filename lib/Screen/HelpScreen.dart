import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
  }

  _appBar() {
    return AppBar(
      title: Text("Help Desk"),
      automaticallyImplyLeading: true,
    );
  }

  _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              _showToast(context);
              //TODO Fix this
//              _launchUrl("tiny.cc/helpdesk_mobile");
            },
            child: CachedNetworkImage(
              color: Colors.white,
              width: 196,
              height: 196,
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/fizmat-original.appspot.com/o/astana.png?alt=media&token=9298fedd-cf4e-43fe-b5c2-40627392aa93",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  _showToast(context);
                  //TODO Fix this
//                  _launchUrl("tiny.cc/fizmat_almaty");
                },
                child: CachedNetworkImage(
                  color: Colors.white,
                  width: 196,
                  height: 196,
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/fizmat-original.appspot.com/o/almaty.png?alt=media&token=3d6dcc1c-751d-4552-aa81-79b7d5e56df0",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          )
        ],
      ),
    );
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
          appBar: _appBar(),
          body: _body(),
        ));
  }

//  _launchUrl(String url) async {
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw ('Couldn\'t launch $url ');
//    }
//  }

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
