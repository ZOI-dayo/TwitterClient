import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

class MainModel extends ChangeNotifier {
  SharedPreferences? prefs;
  final controller = new TextEditingController();

// oauth
  final platform = oauth1.Platform(
    'https://api.twitter.com/oauth/request_token',
    'https://api.twitter.com/oauth/authorize',
    'https://api.twitter.com/oauth/access_token',
    oauth1.SignatureMethods.hmacSha1,
  );
  final clientCredentials = oauth1.ClientCredentials(
    'nGTObtxzjKs0XawEvbxx96RgC',
    'I6z4NZ1BhgXK0oBwDVfpKmLiPJUMIFcnnQUD7PSQMaVfuDqEY0',
  );
  late final auth = oauth1.Authorization(clientCredentials, platform);
  // oauth1.Credentials? tokenCredentials;
  late final client;



  MainModel() {
    print("qaaa");
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  bool hasToken() {
    return prefs?.containsKey('twitter_token') ?? false;
  }

  Future<String> loadToken() async {
    print('Access Token: ${prefs?.getString('twitter_token')}');
    return prefs?.getString('twitter_token') ?? "";
  }

  Future<String> loadTokenSecret() async {
    print('Access Token Secret: ${prefs?.getString('twitter_token_secret')}');
    return prefs?.getString('twitter_token_secret') ?? "";
  }

  Future<bool> setStringPref(String key, String value) {
    Future<bool>? result = prefs?.setString(key, value);
    notifyListeners();
    return result ?? Future.value(false);
  }
}