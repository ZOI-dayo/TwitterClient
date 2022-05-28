import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_test/pages/main_model.dart';
import 'package:twitter_test/pages/main_page.dart';
import 'package:twitter_test/pages/timeline_model.dart';
import 'package:get_it/get_it.dart';

import 'pages/login_model.dart';
import 'state/local.dart';
import 'state/timeline.dart';
GetIt getIt = GetIt.instance;

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton(LocalState(), signalsReady: true);
  getIt.registerSingleton(TimelineState());//, signalsReady: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (context) => MainModel(),
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MainPage()
        ),
      ),
    );
  }
}
