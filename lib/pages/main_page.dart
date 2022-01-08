import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_test/pages/login_page.dart';
import 'package:twitter_test/pages/timeline_model.dart';
import 'package:twitter_test/pages/timeline_page.dart';

import 'login_model.dart';
import 'main_model.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                print(context.toString());
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                        value: new TimelineModel(),
                        child: TimelinePage()
                    )
                ));
              },
              child: Text('Timeline'),
            ),
            ElevatedButton(
              onPressed: () {
                print(context.toString());
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                        value: new LoginModel(),
                        child: LoginPage()
                    )
                )
                );
              },
              child: Text('Login'),
            ),
          ]),
        ),
      ),
    );
  }
}
