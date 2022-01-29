import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:twitter_test/my_database.dart';

import '../twitter_api.dart';
import '../twitter_objects/tweet.dart';
import 'main_model.dart';

class TimelineModel extends ChangeNotifier {
  String apiResponse = "";
  List<Tweet> tweets = [];
  MyDatabase db = MyDatabase();
  bool isLoaded = false;
  DateTime lastRequestTime = DateTime(1,1);

  int Count(BuildContext context) {
    if(tweets.isEmpty){
      getTimeline(context);
      return 0;
    }
    return tweets.length;
  }

  void getTimeline(BuildContext context) async {
    print(lastRequestTime);
    if(lastRequestTime.add(Duration(seconds: 30)).millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch){
      print(lastRequestTime.add(Duration(seconds: 30)).toString() + " > " + DateTime.now().toString());
      print("too early");
      return;
    }
    lastRequestTime = DateTime.now();
    MainModel main = Provider.of<MainModel>(context, listen: false);
    print(main.platform.signatureMethod);
    print(main.clientCredentials);
    var client = new oauth1.Client(
        main.platform.signatureMethod,
        main.clientCredentials,
        new oauth1.Credentials(
            await main.loadToken(), await main.loadTokenSecret()));
    String? latestTweetId = await db.getLatestTweetId();
    final result = await client.get(Uri.parse(
        'https://api.twitter.com/1.1/statuses/home_timeline.json?count=200' + (latestTweetId == null ? "" : "&since_id=" + latestTweetId)));
    // final result = await client.get(Uri.parse('https://api.twitter.com/1.1/statuses/home_timeline.json?count=200'));
    print((await db.getLatestTweetId() ?? ""));
    print(result.request?.url.toString() ?? "");
    apiResponse = result.body;
    print("apiResponse");
    print(apiResponse);
    var decodedResult = jsonDecode(apiResponse) as List;
    print(decodedResult);
    decodedResult.forEach((element) => {
      // tweets.add(new Tweet(element))
      db.addTweet(new Tweet(element))
    });
    tweets = await db.getTweets() ?? [];
    notifyListeners();
  }

  Future<Color> likeColor(int index) async {
    return await TwitterAPI().isLiked(tweets.elementAt(index).id.toString())? Colors.red : Colors.white;
  }
}
