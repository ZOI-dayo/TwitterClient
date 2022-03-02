// https://developer.twitter.com/en/docs/twitter-api/v1/data-dictionary/object-model/tweet

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../widgets/TweetImage.dart';

import 'entities.dart';
import 'user.dart';

class Tweet {
  late final Map tweetObject;
  late final String created_at;
  late final DateTime created_at_date;
  late final int id;
  late final String id_str;
  late final String text;
  late final String source;
  late final bool truncated; // 不必要?
  // Int64? in_reply_to_status_id;
  // Int64? in_reply_to_user_id;
  // String? in_reply_to_screen_name;
  late final User user;

  // Coordinates? coordinates;
  // Places? place;
  // Int64 quoted_status_id;
  // bool is_quote_status;
  // Tweet? quoted_status;// nullableではない、存在しない場合がある?
  late final Tweet? retweeted_status; // nullableではない、存在しない場合がある?
  // int retweet_count;
  // int? favorite_count;
  // Entities entities;
  late final ExpandedEntities? extended_entities;

  // bool? favorited;
  // bool retweeted;
  // bool? possibly_sensitive;
  // String filter_level;
  // String? lang; // BCP 47  Lang型?で保存?
  // Array<Rule> matching_rules;

  // Tweet(String tweetString) {
  Tweet(Map tweetObject) {
    this.tweetObject = tweetObject;
    // var tweetObject = new JsonDecoder().convert(tweetString);
    created_at = tweetObject["created_at"]?.toString().trim() ?? "";
    print("tweetObject" + tweetObject.toString());
    created_at_date = DateFormat('EEE MMM dd hh:mm:ss +0000 yyyy', 'en_US').parse(created_at);
    id = tweetObject["id"];
    id_str = tweetObject["id_str"];
    text = tweetObject["text"] ?? "";
    source = tweetObject["source"] ?? "";
    truncated = tweetObject["truncated"] ?? false;
    user = new User(tweetObject["user"]);
    retweeted_status = tweetObject.containsKey("retweeted_status")
        ? new Tweet(tweetObject["retweeted_status"])
        : null;
    extended_entities = tweetObject.containsKey("extended_entities")
        ? new ExpandedEntities(tweetObject["extended_entities"])
        : null;
  }

  String toStringWithIndent(int offset, int indent) {
    String offsetStr = new List.filled(offset, " ").join();
    String indentStr = new List.filled(indent, " ").join();

    String stringed = "";
    stringed += offsetStr + "{\n";
    stringed += offsetStr + indentStr + "createdTime : $created_at\n";
    stringed += offsetStr + indentStr + "created_at_date : $created_at_date\n";
    stringed += offsetStr + indentStr + "id : $id\n";
    stringed += offsetStr + indentStr + "text : $text\n";
    stringed += offsetStr + indentStr + "source : $source\n";
    stringed += offsetStr + indentStr + "truncated : $truncated\n";
    stringed += offsetStr + "}\n";
    return stringed;
  }

  String toString() {
    return toStringWithIndent(0, 2);
  }

  Widget getTweetContent() {
    // final List<String> images = [];
    // RegExp(r'https:\/\/t.co\/\S+').allMatches(text).forEach((match) {
    //   images.add(match.group(0).toString() ?? "");
    // });
    // final imageRemovedText =
    //     Text(text.replaceAll(RegExp(r'https:\/\/t.co\/\S+'), ""));
    // print(images);
    // final imageView = Row(
    //   children: images.map((e) => Image.network(e)).toList(),
    // );

    Tweet rootTweet = retweeted_status ?? this;

    final images = extended_entities?.media
            .map((e) => Image.network(e.media_url_https, fit: BoxFit.contain))
            .toList() ??
        [];
    final tweetContent = Column(children: [
      // imageRemovedText,
      // imageView,
      if(rootTweet == retweeted_status) Text("RT"),
      Text(rootTweet.text),
      if (images.isNotEmpty) TweetImage(images),
    ]);
    return tweetContent;
  }

  String getJson() {
    return JsonEncoder.withIndent("  ").convert(tweetObject);
  }
}
