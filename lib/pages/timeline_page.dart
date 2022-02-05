import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import './timeline_model.dart';
import '../twitter_objects/tweet.dart';
import '../widgets/TweetWidget.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimelineModel(),
      child: MaterialApp(
        home: _SearchPage(),
      ),
    );
  }
}

class _SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<TimelineModel>().getTimeline(context);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: context
                            .watch<TimelineModel>()
                            .tweets
                            .map((Tweet t) => TweetWidget(
                                () => {context.read<TimelineModel>().refresh()},
                                t))
                            .toList())),
              ),
        ],
      ),
    );
  }
}
