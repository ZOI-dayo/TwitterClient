
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:twitter_test/state/timeline.dart';

class LocalState extends ChangeNotifier {
  SharedPreferences? _prefs;
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


  LocalState();

  Future<SharedPreferences> _pref() async {
    if(_prefs!=null) return Future.value(_prefs!);
    _prefs = await SharedPreferences.getInstance();
    return Future.value(_prefs!);
  }

  bool hasToken() {
    print('prefs=$_prefs');
    String? token = getString("twitter_token");
    print('token=$token');
    return token!=null&&token.length>0;
  }

  Future<String> loadToken() async {
    return _pref().then((value) => Future.value(value.getString('twitter_token')??''));
  }

  Future<String> loadTokenSecret() async {
    return _pref().then((value) =>Future.value(value.getString('twitter_token_secret')??''));
  }

  Future<String> getStringPref(String key) async {
    return _pref().then((value) =>Future.value(value.getString(key)??''));
  }

  String? getString(String key) {
    return _prefs!=null?_prefs!.getString(key):null;
  }

  Future<bool> setStringPref(String key, String value, {bool notify=true}) async {
    Future<bool> result = await _pref().then((p) => p.setString(key, value));
    if(notify) notifyListeners();
    return result;
  }
}