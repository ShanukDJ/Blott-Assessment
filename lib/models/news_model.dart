import 'package:intl/intl.dart';

class NewsModel {
  String? category;
  int? datetime;
  String? headline;
  int? id;
  String? image;
  String? related;
  String? source;
  String? summary;
  String? url;

  NewsModel(
      {this.category,
        this.datetime,
        this.headline,
        this.id,
        this.image,
        this.related,
        this.source,
        this.summary,
        this.url});

  NewsModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    datetime = json['datetime'];
    headline = json['headline'];
    id = json['id'];
    image = json['image'];
    related = json['related'];
    source = json['source'];
    summary = json['summary'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['datetime'] = datetime;
    data['headline'] = headline;
    data['id'] = id;
    data['image'] = image;
    data['related'] = related;
    data['source'] = source;
    data['summary'] = summary;
    data['url'] = url;
    return data;
  }
}

// Extension to convert UNIX timestamp to formatted date
extension NewsModelDateExtension on NewsModel {
  String get formattedDate {
    if (datetime == null) return '';
    var date = DateTime.fromMillisecondsSinceEpoch((datetime ?? 0) * 1000);
    var formatter = DateFormat('d MMMM yyyy');
    return formatter.format(date);
  }
}
