
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oauth1/oauth1.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

import '../../globals.dart';
import '../../state/local.dart';

class LoginPage extends StatefulWidget {

  const LoginPage();

  @override
  State<StatefulWidget> createState() =>_LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = new TextEditingController();
  oauth1.Credentials? tokenCredentials;

  Future<void> openLoginWindow(BuildContext context) async {
    getIt<LocalState>().auth.requestTemporaryCredentials('oob').then((res) {
      tokenCredentials = res.credentials;
      print("oob");
      print(tokenCredentials);
      // launch() で ログイン用URLを開く
      launch(getIt<LocalState>().auth.getResourceOwnerAuthorizationURI(tokenCredentials!.token));
    }).then((value) => {

    });
  }

  Future<void> tryLogin(String pin) async {
    if(pin.isNotEmpty) {
      print("tryLogin");
      await _loginWithPin(pin);
      getIt<LocalState>().getStringPref("twitter_token").then((value) => print("get twitter_token ${value}"));

      print("notifyListeners");
      getIt<GoRouter>().go('/home');
    }
  }

  Future<void> _loginWithPin(String pin) async {
    print('----------------- tokenCredentials');
    if(tokenCredentials!=null) {
      print(tokenCredentials!.token);
      print(tokenCredentials!.tokenSecret);
      print(pin);
    }else{
      print('null '+ (tokenCredentials == null).toString());
      print(pin);
    }
    final res = await getIt<LocalState>().auth.requestTokenCredentials(
        tokenCredentials ?? new Credentials("", ""),
        pin
    );

    await getIt<LocalState>().setStringPref("twitter_token", res.credentials.token);
    await getIt<LocalState>().setStringPref("twitter_token_secret", res.credentials.tokenSecret);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            controller: controller,
          ),
          // Text(context.read<MainModel>().controller.toString()),
          ElevatedButton(
            onPressed: () => openLoginWindow(context),
            child: Text('OpenLoginWindow'),
          ),
          ElevatedButton(
            onPressed: () => tryLogin(controller.value.text),
            child: Text('OK'),
          )
        ]),
      ),
    );;
  }
}