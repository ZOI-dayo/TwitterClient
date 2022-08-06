import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_test/pages/timeline_widget.dart';

import '../globals.dart';
import '../state/timeline.dart';
import './timeline_model.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getIt<TimelineState>().setShowTweet(true);
    return ChangeNotifierProvider<TimelineModel>(
      create: (_) => TimelineModel(),
      child: TimelineWidget(),
    );
  }
}
