import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:twitter_test/twitter_objects/tweet.dart';

class MyDatabase {
  static final MyDatabase _instance = MyDatabase._internal();
  MyDatabase._internal();

  Database? _db;
  factory MyDatabase() {
    Future(() async {
      _instance._db = await openDatabase(
        'myDatabase.db',
        onCreate: _instance.onCreate,
        onOpen: _instance.onOpen,
        onUpgrade: _instance.onUpgrade,
        version: 1,
      );
    });
    return _instance;
  }

  void onCreate(db, version) {
    var sql =
        'create table tweets(id integer primary key, date integer, content text)';
    return db.execute(sql);
  }

  void onOpen(db) async {
    // final List<Map<String, dynamic>> maps = await db.query('tweets');
  }

  void onUpgrade(db, oldVersion, newVersion) {}

  // List<Tweet> selectTweet() {
  //
  // }

  Future<void> addTweet(final Tweet tweet) async {
    var tweetData = {
      "id": tweet.id,
      "date": tweet.created_at_date.millisecondsSinceEpoch,
      "content": tweet.getJson()
    };
    if ((await _db?.query("tweets", where: "id = " + tweet.id_str))
            ?.isNotEmpty ??
        false) {
      print("tweet already exist");
      return;
    }
    _db?.insert('tweets', tweetData);
  }

  Future<List<Tweet>> getTweetsAfterId(int latestId, int count) async {
    List<Map<String, Object?>>? matchTweetsData = (await _db?.query("tweets",
        where: "id > " + latestId.toString(),
        limit: count,
        orderBy: "id DESC"));
    if (matchTweetsData != null && matchTweetsData.length == 10) {
      print(matchTweetsData);
      return matchTweetsData
          .map((tData) =>
              new Tweet(jsonDecode(tData["content"] as String) as Map))
          .toList();
    }

    return [];
  }
  Future<List<Tweet>> getLatestTweets(int count) async {
    List<Map<String, Object?>>? matchTweetsData = (await _db?.query("tweets",
        limit: count,
        orderBy: "id DESC"));
    if (matchTweetsData != null/* && matchTweetsData.length == 10*/) {
      print(matchTweetsData);
      return matchTweetsData
          .map((tData) =>
      new Tweet(jsonDecode(tData["content"] as String) as Map))
          .toList();
    }
    return [];
  }
}
