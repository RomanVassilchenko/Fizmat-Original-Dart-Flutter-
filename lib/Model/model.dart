class Article {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article(
      {this.source,
      this.author,
      this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.content});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        source: Source.fromJsonForArticle(json["source"]),
        author: json['author'],
        title: json['title'],
        description: json['description'],
        url: json['url'],
        urlToImage: json['urlToImage'],
        publishedAt: json['publishedAt'],
        content: json['content']);
  }
}

class Schedule {
  final Source source;
  final String author;
  final String subjectTitle;
  final String classNumber;
  final String indexNumber;
  final String classroom;
  final String dayOfWeek;
  final String time;

  Schedule(
      {this.source,
      this.author,
      this.subjectTitle,
      this.classNumber,
      this.indexNumber,
      this.classroom,
      this.dayOfWeek,
      this.time});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        source: Source.fromJsonForArticle(json["source"]),
        author: json['author'],
        subjectTitle: json['subject_title'],
        classNumber: json['class_number'],
        indexNumber: json['index_number'],
        classroom: json['classroom'],
        dayOfWeek: json['dayOfWeek'],
        time: json['time']);
  }
}

class Source {
  final String id;
  final String name;
  final String url;
  final String flag;

  Source({this.id, this.name, this.url, this.flag});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
        id: json['id'],
        name: json['name'],
        url: json['url'],
        flag: json['flag']);
  }

  factory Source.fromJsonForArticle(Map<String, dynamic> json) {
    return Source(id: json['id'], name: json['name']);
  }
}

class NewsAPI {
  final String status;
  final List<Source> sources;

  NewsAPI({this.status, this.sources});

  factory NewsAPI.fromJson(Map<String, dynamic> json) {
    return NewsAPI(
        status: json['status'],
        sources: (json['sources'] as List)
            .map((source) => Source.fromJson(source))
            .toList());
  }
}

//TODO make Notes Model smaller

class Response {
  int count;
  List<Items> items;

  Response({this.count, this.items});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int id;
  int fromId;
  int ownerId;
  int date;
  String postType;
  String text;
  List<Attachments> attachments;
  Comments comments;
  Comments likes;
  Comments reposts;
  Comments views;

  Items({this.id,
    this.fromId,
    this.ownerId,
    this.date,
    this.postType,
    this.text,
    this.attachments,
    this.comments,
    this.likes,
    this.reposts,
    this.views});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromId = json['from_id'];
    ownerId = json['owner_id'];
    date = json['date'];
    postType = json['post_type'];
    text = json['text'];
    if (json['attachments'] != null) {
      attachments = new List<Attachments>();
      json['attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
      });
    }
    comments = json['comments'] != null
        ? new Comments.fromJson(json['comments'])
        : null;
    likes = json['likes'] != null ? new Comments.fromJson(json['likes']) : null;
    reposts =
    json['reposts'] != null ? new Comments.fromJson(json['reposts']) : null;
    views = json['views'] != null ? new Comments.fromJson(json['views']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_id'] = this.fromId;
    data['owner_id'] = this.ownerId;
    data['date'] = this.date;
    data['post_type'] = this.postType;
    data['text'] = this.text;
    if (this.attachments != null) {
      data['attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.toJson();
    }
    if (this.likes != null) {
      data['likes'] = this.likes.toJson();
    }
    if (this.reposts != null) {
      data['reposts'] = this.reposts.toJson();
    }
    if (this.views != null) {
      data['views'] = this.views.toJson();
    }
    return data;
  }
}

class Attachments {
  String type;
  Link link;

  Attachments({this.type, this.link});

  Attachments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    link = json['link'] != null ? new Link.fromJson(json['link']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.link != null) {
      data['link'] = this.link.toJson();
    }
    return data;
  }
}

class Link {
  String url;
  String title;
  String caption;
  String description;
  Photo photo;
  Button button;

  Link({this.url,
    this.title,
    this.caption,
    this.description,
    this.photo,
    this.button});

  Link.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    caption = json['caption'];
    description = json['description'];
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    button =
    json['button'] != null ? new Button.fromJson(json['button']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    data['caption'] = this.caption;
    data['description'] = this.description;
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    if (this.button != null) {
      data['button'] = this.button.toJson();
    }
    return data;
  }
}

class Photo {
  int id;
  int albumId;
  int ownerId;
  int userId;
  List<Sizes> sizes;
  String text;
  int date;

  Photo({this.id,
    this.albumId,
    this.ownerId,
    this.userId,
    this.sizes,
    this.text,
    this.date});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumId = json['album_id'];
    ownerId = json['owner_id'];
    userId = json['user_id'];
    if (json['sizes'] != null) {
      sizes = new List<Sizes>();
      json['sizes'].forEach((v) {
        sizes.add(new Sizes.fromJson(v));
      });
    }
    text = json['text'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['album_id'] = this.albumId;
    data['owner_id'] = this.ownerId;
    data['user_id'] = this.userId;
    if (this.sizes != null) {
      data['sizes'] = this.sizes.map((v) => v.toJson()).toList();
    }
    data['text'] = this.text;
    data['date'] = this.date;
    return data;
  }
}

class Sizes {
  String type;
  String url;
  int width;
  int height;

  Sizes({this.type, this.url, this.width, this.height});

  Sizes.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Button {
  String title;
  Action action;

  Button({this.title, this.action});

  Button.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    action =
    json['action'] != null ? new Action.fromJson(json['action']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.action != null) {
      data['action'] = this.action.toJson();
    }
    return data;
  }
}

class Action {
  String type;
  String url;

  Action({this.type, this.url});

  Action.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}

class Comments {
  int count;

  Comments({this.count});

  Comments.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}
