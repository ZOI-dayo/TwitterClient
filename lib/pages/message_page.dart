
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'message_model.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessageModel(),
      child: MaterialApp(
        home: _MessagePage(),
      ),
    );
  }
}

class _MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [Text('message')],
      ),
    );
  }
}
