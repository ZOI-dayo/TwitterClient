import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:twitter_test/pages/timeline_model.dart';
import 'package:twitter_test/widgets/TweetWidget.dart';

class TimelinePage extends StatelessWidget{
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
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: context.watch<TimelineModel>().Count(context),
                itemBuilder: (BuildContext context, int index) {
                  return TweetWidget(() => {context.read<TimelineModel>().refresh()}, context.watch<TimelineModel>().tweets[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
