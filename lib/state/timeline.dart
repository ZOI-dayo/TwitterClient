import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import '../pages/timeline_model.dart';
import '../my_database.dart';
import '../../twitter_api.dart';
import '../../twitter_objects/tweet.dart';
import 'local.dart';

class TimelineState {
  String apiResponse = "";
  MyDatabase db = MyDatabase();
  bool isLoaded = false;
  DateTime lastApiRequestTime = DateTime(1, 1);
  GlobalKey scrollWidgetKey = GlobalKey();
  Map<int, GlobalKey> tweetKeyList = Map();
  TwitterAPI _twitterAPI = TwitterAPI();
  bool _showTweet = false;
  final ScrollController controller = ScrollController();

  bool get showTweet => _showTweet;

  TimelineState() {
    GetIt.instance<LocalState>().getStringPref("lastApiRequestTime").then(
        (value) =>
            {if (value.isNotEmpty) lastApiRequestTime = DateTime.parse(value)});
    _twitterAPI.init();
  }

  void setShowTweet(bool b) {
    _showTweet = b;
    TimelineModel().rebuild();
  }

  // 名前変える?
  Future<List<Tweet>> update() async {
    int latestId;
    if (TimelineModel.tweets.isEmpty) {
      latestId = 1;
    } else {
      latestId = TimelineModel.tweets[0].id;
    }
    if (!_twitterAPI.isInitialized) {
      await _twitterAPI.init();
    }

    if (_twitterAPI.client == null) return [];

    List<Tweet> additionTweets = await _twitterAPI.getTimeline(latestId, 10,
        lastApiRequestTime: lastApiRequestTime,
        callback: (_, __, lastTime) => {
              GetIt.instance<LocalState>().setStringPref("lastApiRequestTime",
                  (lastTime ?? DateTime.now()).toIso8601String()),
              lastApiRequestTime = lastTime ?? DateTime.now()
            });
    TimelineModel.tweets.insertAll(0, additionTweets);
    TimelineModel().rebuild();

    double dx = 0;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      additionTweets.forEach((e) {
        /*
        print(dx);
        print(tweetKeyList[e.id]);
        print(tweetKeyList[e.id]?.currentContext);
        print(tweetKeyList[e.id]?.currentWidget);
        print(tweetKeyList[e.id]?.currentState);
         */
        dx += tweetKeyList[e.id]?.currentContext?.size?.height ?? 0;
      });
      controller.jumpTo(dx);
    });
    return TimelineModel.tweets;
  }

  Future<void> refresh() async {
    update();
    TimelineModel().rebuild();
  }

  GlobalKey issueTweetKey(int id) {
    if (tweetKeyList.containsKey(id)) return tweetKeyList[id]!;
    GlobalKey key = GlobalKey();
    tweetKeyList[id] = key;
    return key;
  }
}
