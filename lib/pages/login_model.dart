import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:oauth1/oauth1.dart';
import 'package:provider/provider.dart';
import 'package:twitter_test/pages/main_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

import '../state/local.dart';

GetIt getIt = GetIt.instance;
class LoginModel extends ChangeNotifier {

  static oauth1.Credentials? tokenCredentials;

  Future<void> openLoginWindow(BuildContext context) async {
    // final platform = Provider.of<MainModel>(context, listen: false).platform;
    // final clientCredentials = Provider.of<MainModel>(context, listen: false).clientCredentials;
    // late final auth = Provider.of<MainModel>(context, listen: false).auth;
    MainModel main = Provider.of<MainModel>(context, listen: false);

    getIt<LocalState>().auth.requestTemporaryCredentials('oob').then((res) {
      tokenCredentials = res.credentials;
      print("oob");
      print(tokenCredentials);
      // launch() で ログイン用URLを開く
      launch(getIt<LocalState>().auth.getResourceOwnerAuthorizationURI(tokenCredentials!.token));
    });

    notifyListeners();
  }

  void tryLogin(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context, listen: false);
    final pin = mainModel.controller.text;
    if(context.read<MainModel>().controller.text.isNotEmpty) {
      print("has token");
      _loginWithPin(context, pin);
    }

    mainModel.notifyListeners();
  }
  void _loginWithPin(BuildContext context, String pin) async {
    MainModel main = Provider.of<MainModel>(context, listen: false);
    print(tokenCredentials);
    print(pin);
    final res = await getIt<LocalState>().auth.requestTokenCredentials(
      tokenCredentials ?? new Credentials("", ""),
      pin
    );
    // print(res);
    // print('Access Token: ${res.credentials.token}');
    // print('Access Token Secret: ${res.credentials.tokenSecret}');

    _saveToken(main, res.credentials);

    notifyListeners();
  }

  void _saveToken(MainModel mainModel, Credentials credentials) async {
    print("aaa");
    getIt<LocalState>().setStringPref("twitter_token", credentials.token);
    getIt<LocalState>().setStringPref("twitter_token_secret", credentials.tokenSecret);
    mainModel.notifyListeners();
  }
}
