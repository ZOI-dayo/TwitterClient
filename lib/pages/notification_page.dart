import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'notification_model.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationModel(),
      child: MaterialApp(
        home: _NotificationPage(),
      ),
    );
  }
}

class _NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [Text('notification')],
      ),
    );
  }
}
