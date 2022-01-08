import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:twitter_test/pages/timeline_model.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
            body: Scrollbar(
      isAlwaysShown: false,
      child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          onPressed: () => context.read<TimelineModel>().getTimeline(context),
          child: Text('reload'),
        ),
        // Text(
        //     "${context.watch<TimelineModel>().apiResponse}\n\n${DateTime.now()}"),
        SizedBox(
          height: 700,
          width: 500,
          child: ListView.builder(
            itemCount: context.watch<TimelineModel>().tweets.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 200,
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
                          .getTweetContent()
                    ],
                  ))
                ]),
              );
            },
          ),
        ),
      ])),
    )));
  }
}
