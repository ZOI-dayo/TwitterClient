import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oauth1/oauth1.dart';
import 'package:provider/provider.dart';
import 'package:twitter_test/pages/main_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

class LoginModel extends ChangeNotifier {

  static oauth1.Credentials? tokenCredentials;

  LoginModel(context) {
    MainModel mainModel = Provider.of<MainModel>(context, listen: false);
    if(!mainModel.hasToken()) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => Navigator.pop(context));
    }
  }

  void openLoginWindow(BuildContext context) {
    // final platform = Provider.of<MainModel>(context, listen: false).platform;
    // final clientCredentials = Provider.of<MainModel>(context, listen: false).clientCredentials;
    // late final auth = Provider.of<MainModel>(context, listen: false).auth;
    MainModel main = Provider.of<MainModel>(context, listen: false);

    main.auth.requestTemporaryCredentials('oob').then((res) {
      tokenCredentials = res.credentials;
      print("oob");
      print(tokenCredentials);
      // launch() で ログイン用URLを開く
      launch(main.auth.getResourceOwnerAuthorizationURI(tokenCredentials!.token));
      notifyListeners();
    });
    // _initPrefs(context);

    Provider.of<MainModel>(context).notifyListeners();
    notifyListeners();
  }

  // Future<void> _initPrefs(BuildContext context) async {
  //   MainModel mainModel = Provider.of<MainModel>(context);
  //   mainModel.prefs = await SharedPreferences.getInstance();
  // }

  void tryLogin(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context, listen: false);
    final pin = mainModel.controller.text;
    if(!mainModel.hasToken()) {
       Navigator.pop(context);
    }
    if(context.read<MainModel>().controller.text.isNotEmpty) {
      print("has token");
      _loginWithPin(context, pin);
    }

    Navigator.pop(context);
    mainModel.notifyListeners();
  }
  void _loginWithPin(BuildContext context, String pin) async {
    MainModel main = Provider.of<MainModel>(context, listen: false);
    print(tokenCredentials);
    print(pin);
    final res = await main.auth.requestTokenCredentials(
      tokenCredentials ?? new Credentials("", ""),
      pin
    );
    // print(res);
    // print('Access Token: ${res.credentials.token}');
    // print('Access Token Secret: ${res.credentials.tokenSecret}');

    _saveToken(context, res.credentials);

    notifyListeners();
  }

  void _saveToken(BuildContext context, Credentials credentials) async {
    print("aaa");
    MainModel mainModel = Provider.of<MainModel>(context, listen: false);
    mainModel.setStringPref("twitter_token", credentials.token);
    mainModel.setStringPref("twitter_token_secret", credentials.tokenSecret);
    mainModel.notifyListeners();
  }
}
