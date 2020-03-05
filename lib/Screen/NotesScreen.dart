import 'dart:async';
import 'dart:convert';

import 'package:fizmatoriginal/Model/model.dart';
import 'package:fizmatoriginal/Model/newsCacheManager.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

List<Items> list;
var fullName = new Map();

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  var token =
      "ece24e823adc1d98437a15ffa589b3762c75f75fc62e42ba8878f0cf023cca9d0ab56a45f88687528e7cc";

  Future<List<Items>> getData() async {
    if (list != null) return list;

    var listOfID = [
      -180159908,
      278349593,
    ];

    for (int id in listOfID) {
      if (fullName[id] == null) fullName[id] = await getFullName(id);
      String link =
          "https://api.vk.com/method/wall.get?access_token=$token&v=5.103&owner_id=$id&count=100";

      var fetchedFile = await NewsCacheManager().getSingleFile(link);

      var data = json.decode(fetchedFile.readAsStringSync());
      var rest = data["response"]['items'] as List;
      if (list == null)
        list = rest.map<Items>((json) => Items.fromJson(json)).toList();
      else
        list += rest.map<Items>((json) => Items.fromJson(json)).toList();

      list.removeWhere((item) => item.attachments == null);
      list.removeWhere((item) => item.attachments[0].type != "link");
      list.removeWhere(
              (item) => item.attachments[0].link.description != "Article");
    }

    list.sort((a, b) => b.date.compareTo(a.date));

    return list;
  }

  Future<String> getFullName(int id) async {
    String link = (id >= 0)
        ? "https://api.vk.com/method/users.get?access_token=$token&v=5.103&user_ids=$id"
        : "https://api.vk.com/method/groups.getById?access_token=$token&v=5.103&group_ids=${-id}";

    var fetchedFile = await NewsCacheManager().getSingleFile(link);

    var data = json.decode(fetchedFile.readAsStringSync());
    if (id >= 0) {
      return data['response'][0]["first_name"] +
          " " +
          data['response'][0]["last_name"];
    } else {
      return data['response'][0]["name"];
    }
  }

  Widget listViewWidget(List<Items> note) {
    return Container(
      child: ListView.builder(
          itemCount: note.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            var id = note[position].ownerId;
            var attachment = note[position].attachments;
            var link = attachment != null ? attachment[0].link : null;
            var url = link != null ? link.url : null;
            var title = link != null ? link.title : null;
            var imageUrl = link != null ? link.photo.sizes[4].url : null;

            return Card(
              margin: const EdgeInsets.only(bottom: 2.0),
              color: Color.fromRGBO(32, 33, 37, 1),
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 20, right: 0),
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(5.0),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(imageUrl)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${title}',
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                  (fullName.containsKey(id))
                                      ? fullName[id]
                                      : "No Name",
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () => _launchUrl(url),
              ),
            );
          }),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw ('Couldn\'t launch $url ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(61, 62, 66, 1),
      appBar: AppBar(
        title: Text("Статьи"),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              return listViewWidget(snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
