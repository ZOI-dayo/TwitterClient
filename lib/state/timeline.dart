import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:twitter_test/my_database.dart';
import '../../twitter_api.dart';
import '../../twitter_objects/tweet.dart';
import 'local.dart';

class TimelineState extends ChangeNotifier {

  String apiResponse = "";
  List<Tweet> _tweets = [];
  MyDatabase db = MyDatabase();
  bool isLoaded = false;
  DateTime lastApiRequestTime = DateTime(1,1);
  GlobalKey scrollWidgetKey = GlobalKey();
  Map<int, GlobalKey> tweetKeyList = Map();
  TwitterAPI _twitterAPI = TwitterAPI();
  bool _showTweet = false;
  bool get showTweet => _showTweet;

  TimelineState(){
    GetIt.instance<LocalState>().getStringPref("lastApiRequestTime").then((value) => {if(value.isNotEmpty) lastApiRequestTime= DateTime.parse(value)});
    _twitterAPI.init();
  }

  int Count() {
    if(_tweets.isEmpty){
      getTimeline();
      return 0;
    }
    return _tweets.length;
  }

  void setShowTweet(bool b){
    _showTweet = b;
    notifyListeners();
  }

  Future<List<Tweet>> getTimeline() async {
    int latestId;
    if (_tweets.isEmpty) {
      latestId = 1;
    } else {
      latestId = _tweets[0].id;
    }
    if(!_twitterAPI.isInitialized){
      await _twitterAPI.init();
    }

    if(_twitterAPI.client == null) [];

    List<Tweet> additionTweets = await _twitterAPI.getTimeline(
        latestId,
        10,
        lastApiRequestTime: lastApiRequestTime,
        callback: (_,__,lastTime) => {
          GetIt.instance<LocalState>().setStringPref(
              "lastApiRequestTime", (lastTime ?? DateTime.now()).toIso8601String()
          ),
          lastApiRequestTime = lastTime ?? DateTime.now()
        });
    _tweets.insertAll(0, additionTweets);

    if (_tweets.length > 20) _tweets = _tweets.sublist(0, 20);
    SchedulerBinding.instance.addPostFrameCallback((_) => {
      if (tweetKeyList.containsKey(latestId) && tweetKeyList[latestId]!.currentContext != null)
        {
          print("ensure"),
          Scrollable.ensureVisible(
              tweetKeyList[latestId]!.currentContext!,
              alignment: 0.0,
              duration: Duration.zero,
              curve: Curves.ease,
              alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd)
        }
    });
    return _tweets;
  }

  Future<void> refresh() async {
    getTimeline();
    notifyListeners();
  }

  GlobalKey issueTweetKey(int id) {
    GlobalKey key = GlobalKey();
    tweetKeyList[id] = key;
    return key;
  }
}