import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:twitter_test/pages/timeline_model.dart';
import 'package:twitter_test/twitter_api.dart';

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
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // color: Color.fromARGB(255, 255, 255, 0),
                    child: Row(children: [
                      // Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                      Image.network(context
                          .watch<TimelineModel>()
                          .tweets
                          .elementAt(index)
                          .user
                          .profile_image_url_https),
                      Flexible(
                          child: Column(
                            children: [
                              Text(
                                  context
                                      .watch<TimelineModel>()
                                      .tweets
                                      .elementAt(index)
                                      .user
                                      .name,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              context
                                  .watch<TimelineModel>()
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
                                              .read<TimelineModel>()
                                              .tweets
                                              .elementAt(index)
                                              .id
                                              .toString());
                                          context
                                              .read<TimelineModel>()
                                              .notifyListeners();
                                        },
                                        child: Consumer<TimelineModel>(
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
