import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_test/pages/home_page.dart';
import 'package:twitter_test/pages/login_page.dart';
import 'package:twitter_test/pages/timeline_page.dart';

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
    final bool _hasToken = context.watch<MainModel>().hasToken();
    return _hasToken? HomePage() : LoginPage();
  }
}
