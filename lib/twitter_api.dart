import 'dart:convert';

import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:shared_preferences/shared_preferences.dart';
import './twitter_objects/tweet.dart';

class TwitterAPI {
  static final TwitterAPI _instance = TwitterAPI._internal();
  TwitterAPI._internal();
  factory TwitterAPI() {
    _instance.init();
    return _instance;
  }

  var prefs;
  final _platform = oauth1.Platform(
    'https://api.twitter.com/oauth/request_token',
    'https://api.twitter.com/oauth/authorize',
    'https://api.twitter.com/oauth/access_token',
    oauth1.SignatureMethods.hmacSha1,
  );
  final _clientCredentials = oauth1.ClientCredentials(
    'nGTObtxzjKs0XawEvbxx96RgC',
    'I6z4NZ1BhgXK0oBwDVfpKmLiPJUMIFcnnQUD7PSQMaVfuDqEY0',
  );
  var client;

  void init() async {
    if(prefs == null) prefs = await SharedPreferences.getInstance();
    if(client == null) client = new oauth1.Client(
        _platform.signatureMethod, _clientCredentials,
        new oauth1.Credentials(await _loadToken(prefs), await _loadTokenSecret(prefs)));
  }
  Future<String> _loadToken(prefs) async {
    print('Access Token: ${prefs.getString('twitter_token')}');
    return prefs.getString('twitter_token') ?? "";
  }

  Future<String> _loadTokenSecret(prefs) async {
    print('Access Token Secret: ${prefs.getString('twitter_token_secret')}');
    return prefs.getString('twitter_token_secret') ?? "";
  }

  Future<dynamic> _request(String location, [String type = 'GET', String version = '1.1']) async {
    final result;
    switch(type){
      case 'GET':
        result = await client.get(Uri.parse('https://api.twitter.com/' + version + '/' + location));
        break;
      case 'POST':
        result = await client.post(Uri.parse('https://api.twitter.com/' + version + '/' + location));
        break;
      default:
        return {};
    }
    final body = result.body;
    return jsonDecode(body);
  }

  List<String> likes = [];
  void like(String tweetId) async {
    _request('favorites/create.json?id=' + tweetId, 'POST');
    likes.add(tweetId);
  }

  Future<bool> isLiked(String tweetId) async {
    if(likes.length <= 0) {
      likes = ((await _request('favorites/list.json?count=200')) as List).map((e) => new Tweet(e).id.toString()).toList();
      print(likes);
    }
    return likes.contains(tweetId);
  }

  Future<List<Tweet>> getTimeline(String? latestTweetId) async {
    var result = await _request('statuses/home_timeline.json?count=200' + (latestTweetId == null ? "" : "&since_id=" + latestTweetId), 'GET');
    if(result is Map && result.containsKey("errors")){
      print("ERROR : " + result.toString());
      return [];
    }
    List tweetData = result as List;
    List<Tweet> tweetObjects = [];
    tweetData.forEach((data) => {
      tweetObjects.add(new Tweet(data))
    });
    return tweetObjects;
  }
}