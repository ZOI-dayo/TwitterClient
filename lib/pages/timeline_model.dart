import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:twitter_test/my_database.dart';

import '../twitter_api.dart';
import '../twitter_objects/tweet.dart';

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
    if(lastRequestTime.add(Duration(seconds: 30)).millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch){
      print(lastRequestTime.add(Duration(seconds: 30)).toString() + " > " + DateTime.now().toString());
      print("too early");
      return;
    }
    lastRequestTime = DateTime.now();
    List<Tweet> tweetsData = await TwitterAPI().getTimeline(await db.getLatestTweetId());
    for(Tweet tweet in tweetsData) await db.addTweet(tweet);
    tweets = await db.getTweets() ?? [];
    notifyListeners();
  }

  Future<Color> likeColor(int index) async {
    return await TwitterAPI().isLiked(tweets.elementAt(index).id.toString())? Colors.red : Colors.white;
  }

  void refresh() {
    notifyListeners();
  }
}
