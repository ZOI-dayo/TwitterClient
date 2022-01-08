import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_test/pages/main_model.dart';
import 'package:twitter_test/pages/main_page.dart';
import 'package:twitter_test/pages/timeline_model.dart';

import 'pages/login_model.dart';

void main() {
  runApp(MyApp());
  // MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider(create: (context) => new MainModel()),
  //     // ChangeNotifierProvider(create: (context) => TimelineModel()),
  //     // ChangeNotifierProvider(create: (context) => LoginModel()),
  //   ],
  //   child: MaterialApp(
  //       title: 'Flutter Demo',
  //       theme: ThemeData(
  //         primarySwatch: Colors.blue,
  //       ),
  //       home: MainPage()
  //   ),
  // ),
  //   Navigator.push(
  //       context, MaterialPageRoute(
  //       builder: (context) => ChangeNotifierProvider.value(
  //           value: new MainModel(),
  //           child: MainPage()
  //       )
  //   ));
  // ChangeNotifierProvider(value: (context) => new MainModel()),
  //       child: MaterialApp(
  //           title: 'Flutter Demo',
  //           theme: ThemeData(
  //             primarySwatch: Colors.blue,
  //           ),
  //           home: MainPage()
  //       ),
  //     )),
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
        create: (context) => new MainModel(),
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MainPage()),
      ),
    );
  }
}
