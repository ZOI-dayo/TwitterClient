import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import 'home_model.dart';
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
                context.read<HomeModel>().getTimeline(context);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: context.watch<HomeModel>().Count(context),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // color: Color.fromARGB(255, 255, 255, 0),
                    child: Row(children: [
                      // Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                      Image.network(context
                          .watch<HomeModel>()
                          .tweets
                          .elementAt(index)
                          .user
                          .profile_image_url_https),
                      Flexible(
                          child: Column(
                            children: [
                              Text(
                                  context
                                      .watch<HomeModel>()
                                      .tweets
                                      .elementAt(index)
                                      .user
                                      .name,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              context
                                  .watch<HomeModel>()
                                  .tweets
                                  .elementAt(index)
                                  .getTweetContent(),
                              SizedBox(
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Icon(Icons.comment),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.transparent,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          TwitterAPI().like(context
                                              .read<HomeModel>()
                                              .tweets
                                              .elementAt(index)
                                              .id
                                              .toString());
                                          context
                                              .read<TimelineModel>()
                                              .notifyListeners();
                                        },
                                        child: Consumer<HomeModel>(
                                          builder: (_, model, widget) {
                                            return FutureBuilder(
                                              future: model.likeColor(index),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<Color> snapshot) {
                                                if (snapshot.hasData) {
                                                  return Icon(Icons.favorite,
                                                      color: snapshot.data);
                                                } else {
                                                  return Icon(Icons.favorite);
                                                }
                                              },
                                            );
                                          },
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.transparent,
                                          // primary: Colors.red,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Icon(Icons.loop),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.transparent,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Icon(Icons.bookmark_border),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.transparent,
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ))
                    ]),
                  );
                },
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
