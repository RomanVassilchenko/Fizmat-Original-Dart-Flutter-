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
  final String subject_title;
  final String class_number;
  final String index_number;
  final String classroom;
  final String dayOfWeek;
  final String time;

  Schedule(
      {this.source,
      this.author,
      this.subject_title,
      this.class_number,
      this.index_number,
      this.classroom,
      this.dayOfWeek,
      this.time});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        source: Source.fromJsonForArticle(json["source"]),
        author: json['author'],
        subject_title: json['subject_title'],
        class_number: json['class_number'],
        index_number: json['index_number'],
        classroom: json['classroom'],
        dayOfWeek: json['dayOfWeek'],
        time: json['time']);
  }
}

class Source {
  final String id;
  final String name;
  final String url;

  Source({this.id, this.name, this.url});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'], name: json['name'], url: json['url']);
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
