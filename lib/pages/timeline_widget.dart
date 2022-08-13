import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:twitter_test/pages/timeline_model.dart';
import 'package:twitter_test/state/timeline.dart';
import 'package:twitter_test/widgets/TweetWidget.dart';

import '../globals.dart';

class TimelineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (TimelineModel.tweets.length == 0) getIt<TimelineState>().refresh();
    return RefreshIndicator(
      onRefresh: () async {
        await getIt<TimelineState>().refresh();
      },
      child: SingleChildScrollView(
        controller: getIt<TimelineState>().controller,
        child: Column(
          children: context.watch<TimelineModel>().getTweets().map((e) {
            return TweetWidget(e);
          }).toList(),
        ),
      ),
    );
  }
}
