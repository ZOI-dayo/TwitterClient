import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home_model.dart';
import '../twitter_objects/tweet.dart';
import '../twitter_api.dart';

class TweetWidget extends Container {
  TweetWidget(HomeModel model, Tweet tweet)
      : super(
          key: model.issueTweetKey(tweet.id),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Image.network(tweet.user.profile_image_url_https),
            Flexible(
                child: Column(
              children: [
                Text(tweet.user.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                tweet.getTweetContent(),
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
                        TwitterAPI().like(tweet.id_str);
                        model.refresh();
                      },
                      child: Consumer<HomeModel>(
                        builder: (_, __, ___) {
                          return FutureBuilder(
                            future: TweetWidget.getLikeColor(tweet),
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

  static Future<Color> getLikeColor(Tweet tweet) async {
    return await TwitterAPI().isLiked(tweet.id_str) ? Colors.red : Colors.white;
  }
}
