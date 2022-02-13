import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:twitter_test/my_database.dart';
import '../twitter_api.dart';
import '../twitter_objects/tweet.dart';
import 'main_model.dart';

class HomeModel extends ChangeNotifier {

  int selectedTab = 0;

  String apiResponse = "";
  List<Tweet> tweets = [];
  MyDatabase db = MyDatabase();
  bool isLoaded = false;
  DateTime lastApiRequestTime = DateTime(1,1);
  MainModel? mainModel;
  GlobalKey scrollWidgetKey = GlobalKey();
  Map<int, GlobalKey> tweetKeyList = Map();

  HomeModel(MainModel model){
    mainModel = model;
    mainModel!.getStringPref("lastApiRequestTime").then((value) => {if(value.isNotEmpty) lastApiRequestTime= DateTime.parse(value)});
  }

  int Count(BuildContext context) {
    if(tweets.isEmpty){
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
    List<Tweet> additionTweets = await db.getTweetsAfterId(
        latestId,
        10,
        lastApiRequestTime: lastApiRequestTime,
        callback: (_,__,lastTime) => {
          mainModel!.setStringPref(
              "lastApiRequestTime", (lastTime ?? DateTime.now()).toIso8601String()
          ),
          lastApiRequestTime = lastTime ?? DateTime.now()
        });
    tweets.insertAll(0, additionTweets);
    if (tweets.length > 20) tweets = tweets.sublist(0, 20);
    SchedulerBinding.instance?.addPostFrameCallback((_) => {
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
    notifyListeners();
  }

  Future<Color> likeColor(int index) async {
    return await TwitterAPI().isLiked(tweets.elementAt(index).id.toString())
        ? Colors.red
        : Colors.white;
  }

  GlobalKey issueTweetKey(int id) {
    GlobalKey key = GlobalKey();
    tweetKeyList[id] = key;
    return key;
  }

  void selectTab(int index){
    selectedTab = index;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

}