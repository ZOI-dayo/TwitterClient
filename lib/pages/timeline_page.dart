import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import './home_model.dart';
import './timeline_model.dart';
import '../twitter_objects/tweet.dart';
import '../widgets/TweetWidget.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  context.read<HomeModel>().refresh();
                },
                child: FutureBuilder(
                  future: context.read<HomeModel>().getTimeline(),
                    builder: (BuildContext context, AsyncSnapshot<List<Tweet>> snapshot) {
                    return SingleChildScrollView(
                        key: context.read<HomeModel>().scrollWidgetKey,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                            children: snapshot.data
                                ?.map((Tweet t) =>
                                    TweetWidget(context.read<HomeModel>(), t) as Widget)
                                .toList() ?? [Text('no items')]));
                  }
                )),
          ),
        ],
      ),
    );
  }
}
