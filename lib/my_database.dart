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

  void onUpgrade(db, oldVersion, newVersion) {

  }

  // List<Tweet> selectTweet() {
  //
  // }

  Future<void> addTweet(final Tweet tweet) async {
    var tweetData = {
      "id": tweet.id,
      "date": tweet.created_at_date.millisecondsSinceEpoch,
      "content": tweet.getJson()
    };
    _db?.insert('tweets', tweetData);
  }

  Future<List<Tweet>?> getTweets() async {
    final res = await _db?.query("tweets", orderBy: "id DESC");
    return res?.isNotEmpty ?? false ? res?.map((e) => new Tweet(JsonDecoder().convert(e["content"].toString()))).toList() : [];
  }

  Future<String?> getLatestTweetId() async {
    final maxId = (await _db?.rawQuery("SELECT MAX(id) as max_id from tweets"))?[0]["max_id"].toString();
    print(maxId.toString());
    return maxId;
  }

}