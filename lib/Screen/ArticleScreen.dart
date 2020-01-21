import 'dart:convert';

import 'package:fizmatoriginal/Model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

String apiKey = "AKfycbzkpgPRlnZ18dMC8WlxSeSrlwNIwAo0nwAEr29XYbJHvbQFNMY";

http.Response response;

Future<List<Article>> fetchArticleBySource() async {
  if (response == null)
    response =
    await http.get('https://script.google.com/macros/s/$apiKey/exec');
  if (response.statusCode == 200) {
    List articles = json.decode(response.body)['articles'];
    return articles.map((article) => new Article.fromJson(article)).toList();
  } else {
    throw Exception("Failed to load article list");
  }
}

class ArticleScreen extends StatefulWidget {
  final String url, title;

  ArticleScreen({Key key, @required this.url, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen> {
  var listArticle;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshListArticle();
  }

  Future<Null> refreshListArticle() async {
    refreshKey.currentState?.show(atTop: false);
    apiKey = widget.url;

    setState(() {
      listArticle = fetchArticleBySource();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EDMT News',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Scaffold(
          backgroundColor: Color.fromRGBO(61, 62, 66, 1),
          appBar: AppBar(
              title: Text(widget.title),
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              )),
          body: Center(
            child: RefreshIndicator(
                key: refreshKey,
                child: FutureBuilder<List<Article>>(
                  future: listArticle,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else if (snapshot.hasData) {
                      List<Article> articles = snapshot.data;
                      return ListView(
                        children: articles
                            .map((article) => GestureDetector(
                                  onTap: () {
                                    _launchUrl(article.url);
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0)),
                                    color: Color.fromRGBO(32, 33, 37, 1),
                                    elevation: 0.0,
                                    margin: const EdgeInsets.only(bottom: 2.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 20.0,
                                                              bottom: 10.0),
                                                      child: Text(
                                                        '${article.title}',
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  '${article.description}',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Color.fromRGBO(
                                                          223, 223, 226, 1),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.bottomLeft,
                                                margin: const EdgeInsets.only(
                                                    left: 8.0,
                                                    top: 10.0,
                                                    bottom: 10.0),
                                                child: Text(
                                                  article.publishedAt.length <
                                                          10
                                                      ? '${article.publishedAt}'
                                                      : '${article.publishedAt.substring(0, 10)}',
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Color.fromRGBO(
                                                          191, 192, 197, 1),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 20.0, horizontal: 15.0),
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    article.urlToImage)),
                                          ),
                                        ),
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
                onRefresh: refreshListArticle),
          ),
        ));
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw ('Couldn\'t launch $url ');
    }
  }
}
