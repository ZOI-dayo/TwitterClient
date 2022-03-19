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
  late final oauth1.Client client;

  bool isInitialized = false;

  late final User myTwitterAccount;

  Future<void> init() async {
    if(isInitialized) return;
    isInitialized = true;
    if(prefs == null) prefs = await SharedPreferences.getInstance();
    if(client == null) client = new oauth1.Client(
        _platform.signatureMethod, _clientCredentials,
        new oauth1.Credentials(await _loadToken(prefs), await _loadTokenSecret(prefs)));
    myTwitterAccount = _request('users/show.json') as User;
  }
  Future<String> _loadToken(prefs) async {
    print('Access Token: ${prefs.getString('twitter_token')}');
    return prefs.getString('twitter_token') ?? "";
  }

  Future<String> _loadTokenSecret(prefs) async {
    print('Access Token Secret: ${prefs.getString('twitter_token_secret')}');
    return prefs.getString('twitter_token_secret') ?? "";
  }

  Future<dynamic> _request(String location, [String type = 'GET', String? sendBody, String version = '1.1']) async {

    final result;
    switch(type){
      case 'GET':
        print(client);
        result = await client.get(Uri.parse('https://api.twitter.com/' + version + '/' + location));
        break;
      case 'POST':
        result = await client.post(Uri.parse('https://api.twitter.com/' + version + '/' + location), headers: sendBody == null ? null : {'Content-type': 'application/json'}, body: sendBody);
        break;
      default:
        return {};
    }
    final body = result.body;
    return jsonDecode(body);
  }

  List<String> likes = [];
  void like(Tweet tweet) async {
    _request('favorites/create.json?id=' + tweet.id_str, 'POST');
    likes.add(tweet.id_str);
  }

  List<String> retweets = [];
  void retweet(Tweet tweet) async {
    _request('users/'+ myTwitterAccount.id_str +'/retweets', 'POST', '{"tweet_id": ' + tweet.id_str + '}', '2');
    retweets.add(tweet.id_str);
  }

  Future<List<Tweet>> getTimeline(int latestId, int count, {DateTime? lastApiRequestTime, void callback(int latestId, int count, DateTime? lastApiRequestTime)?}) async {
    List<Tweet>? matchTweetsData = await MyDatabase().getTweetsAfterId(latestId, count);

    if(!matchTweetsData.isEmpty) {
      matchTweetsData.forEach((element) { debugPrint(element.toString());});
      return matchTweetsData;
    }

    if(lastApiRequestTime != null){
      if (lastApiRequestTime.add(Duration(seconds: 5)).millisecondsSinceEpoch >
          DateTime.now().millisecondsSinceEpoch) {
        print("too early");
        return [];
      }
      lastApiRequestTime = DateTime.now();
    }


    List<Tweet> tweetsData = await _getTimeline(latestId.toString());
    for (Tweet tweet in tweetsData) {
      await MyDatabase().addTweet(tweet);
      matchTweetsData.add(tweet);
    }

    return matchTweetsData;
  }

  Future<List<Tweet>> _getTimeline(String? latestTweetId) async {
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