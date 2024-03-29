import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_test/pages/home_page.dart';

import '../globals.dart';
import '../state/local.dart';
import '../state/timeline.dart';
import 'main_model.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainModel(),
      child: MaterialApp(
        home: _TokenCheck(),
      ),
    );
  }
}

class _TokenCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ログイン状態に応じて、画面を切り替える
    debugPrint('=============-- incoming _TokenCheck');
    return Scaffold(
        body: FutureBuilder<String>(
            future: getIt<LocalState>().loadToken(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.data != null && snapshot.data!.isNotEmpty) return HomePage();
                return createLogin(context);
              }
              return Container(child: Text('logind now'));
            }
        ),
    );
  }

  Widget createLogin(BuildContext context) {
    debugPrint('=============-- incoming _LoginPage');
    MainModel mainModel = context.watch<MainModel>();
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextFormField(
        controller: mainModel.controller,
      ),
      // Text(context.read<MainModel>().controller.toString()),
      ElevatedButton(
        onPressed: () => mainModel.openLoginWindow(context),
        child: Text('OpenLoginWindow'),
      ),
      ElevatedButton(
        onPressed: () => mainModel.tryLogin(mainModel.controller.value.text),
        child: Text('OK'),
      )
    ]);
  }
}
