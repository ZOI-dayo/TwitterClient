
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../twitter_api.dart';
import '../twitter_objects/tweet.dart';

DateFormat displayFormat = DateFormat('yyyy/MM/dd');
class SearchModel extends ChangeNotifier {
  DateTime fromDate = new DateTime.now();
  DateTime toDate = new DateTime.now();
  TwitterAPI _twitterAPI = TwitterAPI();
  final searchUserControler = TextEditingController();
  String? keyword;
  GlobalKey scrollWidgetKey = GlobalKey();

  Future<DateTime?> selectDate(BuildContext context, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360))
    );
    return picked;
  }

  void setFromDate(DateTime? d){
    if(d!=null) {
      this.fromDate = d;
      notifyListeners();
    }
  }

  void setToDate(DateTime? d){
    if(d!=null) {
      this.toDate = d;
      notifyListeners();
    }
  }

  void searchTweet(String keyword){
    this.keyword = keyword;
    notifyListeners();
  }


  Future<List<Tweet>> getTimeline() async {
    if(!_twitterAPI.isInitialized){
      await _twitterAPI.init();
    }

    print('_twitterAPI.client= ${_twitterAPI.client}');
    if(_twitterAPI.client == null) return [];
    print('keyword= ${keyword}');
    if(keyword == null) return [];

    List<Tweet> additionTweets = await _twitterAPI.searchTimeline(keyword);
    print('*********** _getTimeline= ${additionTweets.length}');
    return additionTweets;
  }

}