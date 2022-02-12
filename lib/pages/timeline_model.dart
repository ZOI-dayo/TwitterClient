import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:twitter_test/my_database.dart';

import '../twitter_api.dart';
import '../twitter_objects/tweet.dart';

class TimelineModel extends ChangeNotifier {
  String apiResponse = "";
  List<Tweet> tweets = [];
  MyDatabase db = MyDatabase();
  bool isLoaded = false;
  DateTime lastRequestTime = DateTime(1, 1);
  GlobalKey scrollWidgetKey = GlobalKey();
  Map<int, GlobalKey> tweetKeyList = Map();

  int Count(BuildContext context) {
    if (tweets.isEmpty) {
      getTimeline(context);
      return 0;
    }
    return tweets.length;
  }

  void getTimeline(BuildContext context) async {
    int latestId;
    if (tweets.isEmpty) {
      latestId = -1;
    } else {
      latestId = tweets[0].id;
    }
    List<Tweet> additionTweets = await db.getTweetsAfterId(latestId, 10);
    tweets.insertAll(0, additionTweets);
    if (tweets.length > 20) tweets = tweets.sublist(0, 20);
    notifyListeners();
    SchedulerBinding.instance?.addPostFrameCallback((_) => {
          if (tweetKeyList.containsKey(latestId) && tweetKeyList[latestId]!.currentContext != null)
            {
              Scrollable.ensureVisible(
                  tweetKeyList[latestId]!.currentContext!,
                  alignment: 0.0,
                  duration: Duration.zero,
                  curve: Curves.ease,
                  alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd)
            }
        });
  }

  Future<Color> likeColor(int index) async {
    return await TwitterAPI().isLiked(tweets.elementAt(index).id.toString())
        ? Colors.red
        : Colors.white;
  }

  void refresh() {
    notifyListeners();
  }

  GlobalKey issueTweetKey(int id) {
    GlobalKey key = GlobalKey();
    tweetKeyList[id] = key;
    return key;
  }
}
