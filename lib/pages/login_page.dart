import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:twitter_test/pages/login_model.dart';
import 'package:twitter_test/pages/main_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextFormField(
        controller: context.read<MainModel>().controller,
      ),
      // Text(context.read<MainModel>().controller.toString()),
      ElevatedButton(
        onPressed: () => context.read<LoginModel>().openLoginWindow(context),
        child: Text('OpenLoginWindow'),
      ),
        ElevatedButton(
        onPressed: () => context.read<LoginModel>().tryLogin(context),
        child: Text('OK'),
      )
    ]));
  }
}
