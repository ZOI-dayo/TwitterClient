// https://developer.twitter.com/en/docs/twitter-api/v1/data-dictionary/object-model/tweet

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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
  late final int retweet_count;
  late final int favorite_count;

  late final Entities? entities;
  late final Entities? extended_entities;

  late final bool favorited;
  late final bool retweeted;

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
    created_at_date =
        DateFormat('EEE MMM dd hh:mm:ss +0000 yyyy', 'en_US').parse(created_at);
    id = tweetObject["id"];
    id_str = tweetObject["id_str"];
    text = tweetObject["text"] ?? "";
    source = tweetObject["source"] ?? "";
    truncated = tweetObject["truncated"] ?? false;
    user = new User(tweetObject["user"]);
    retweeted_status = tweetObject.containsKey("retweeted_status")
        ? new Tweet(tweetObject["retweeted_status"])
        : null;
    retweet_count = tweetObject["retweet_count"];
    favorite_count = tweetObject["favorite_count"];
    entities = tweetObject.containsKey("entities")
        ? new Entities(tweetObject["entities"])
        : null;
    extended_entities = tweetObject.containsKey("extended_entities")
        ? new Entities(tweetObject["extended_entities"])
        : null;
    favorited = tweetObject["favorited"];
    retweeted = tweetObject["retweeted"];
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

  List<_StyleSpan> _ConvertText(
      RegExp pattern, List<_StyleSpan> source, int power,
      {Function? onTap}) {
    List<_StyleSpan> tagCompiledText = [];
    for (var compilingSpan in source) {
      if (compilingSpan.power >= power) {
        tagCompiledText.add(compilingSpan);
      }
      var compilingText = compilingSpan.text ?? "";
      // url切り出し
      while (pattern.hasMatch(compilingText)) {
        var matched = pattern.firstMatch(compilingText);
        if (matched == null) break;
        tagCompiledText
            .add(_StyleSpan(compilingText.substring(0, matched.start)));
        tagCompiledText.add(_StyleSpan(
            compilingText.substring(matched.start, matched.end),
            style: _StyleSpan.defaultStyle.apply(color: Colors.blue),
            power: power,
            onTap: onTap));
        compilingText = compilingText.substring(matched.end);
      }
      tagCompiledText.add(_StyleSpan(compilingText));
    }
    return tagCompiledText;
  }

  Widget getTweetContent(BuildContext context, {bool retweeted = false}) {
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
    String visibleText = text;
    ((entities?.media ?? []) + (extended_entities?.media ?? [])).forEach(
        (media) => {visibleText = visibleText.replaceAll(media.url, "")});

    List<_StyleSpan> compiledText = [new _StyleSpan(visibleText)];
    // URL
    compiledText = _ConvertText(RegExp(r'https:\/\/\S+'), compiledText, 100,
        onTap: (String text) async {
      try {
        await launch(text);
      } catch (e) {
        print(e);
      }
    });
    // HashTag
    compiledText = _ConvertText(RegExp(r'#\S+'), compiledText, 100);

    final imageUrls =
        extended_entities?.media.map((e) => e.media_url_https).toList() ?? [];
    final tweetContent = Column(children: [
      // imageRemovedText,
      // imageView,
      RichText(
        text: TextSpan(
          children: <TextSpan>[
                if (retweeted) TextSpan(text: "RT"),
              ] +
              compiledText,
        ),
      ),
      if (imageUrls.isNotEmpty) TweetImage(context, this, imageUrls),
    ]);
    return tweetContent;
  }

  String getJson() {
    return JsonEncoder.withIndent("  ").convert(tweetObject);
  }

  bool isRetweeted() {
    return (retweeted_status?.id ?? id) != id;
  }
}

class _StyleSpan extends TextSpan {
  late final power;
  static const defaultStyle = TextStyle(color: Colors.black, fontSize: 18);

  _StyleSpan(String text,
      {TextStyle style = defaultStyle, this.power = 0, Function? onTap})
      : super(
            text: text,
            style: style,
            recognizer: TapGestureRecognizer()
              ..onTap = () => onTap?.call(text));
}
