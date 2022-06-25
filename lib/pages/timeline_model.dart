import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

import '../twitter_api.dart';
import '../twitter_objects/tweet.dart';

class TimelineModel extends ChangeNotifier {
  TimelineModel(BuildContext context){
  }

  void like(Tweet tweet) {
    TwitterAPI().like(tweet);
    notifyListeners();
  }

  void retweet(Tweet tweet) {
    TwitterAPI().retweet(tweet);
    notifyListeners();
  }

  void share(Tweet tweet) {
    ShareExtend.share(tweet.text, "text");
  }

  Color getLikeColor(Tweet tweet) {
    return tweet.favorited || TwitterAPI().likes.contains(tweet.id_str)
        ? Colors.red
        : Colors.white;
  }

  Color getRetweetColor(Tweet tweet) {
    return tweet.retweeted || TwitterAPI().retweets.contains(tweet.id_str)
        ? Colors.red
        : Colors.white;
  }
}
