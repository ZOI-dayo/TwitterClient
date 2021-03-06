import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../state/timeline.dart';
import './timeline_model.dart';
import '../twitter_objects/tweet.dart';
import '../widgets/TweetWidget.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getIt<TimelineState>().setShowTweet(true);
    return ChangeNotifierProvider(
      create: (context) => TimelineModel(context),
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
                  getIt<TimelineState>().refresh();
                },
                child: FutureBuilder(
                  future: getIt<TimelineState>().getTimeline(),
                    builder: (BuildContext context, AsyncSnapshot<List<Tweet>> snapshot) {
                    return SingleChildScrollView(
                        key: getIt<TimelineState>().scrollWidgetKey,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                            children: snapshot.data
                                ?.map((Tweet t) => TweetWidget(t))
                                .toList() ?? [Text('no items')]));
                  }
                )),
          ),
        ],
      ),
    );
  }
}
