import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home_model.dart';
import '../twitter_objects/tweet.dart';
import '../twitter_api.dart';

class TweetWidget extends StatelessWidget {
  HomeModel model;
  Tweet tweet;

  TweetWidget(this.model, this.tweet) : super();

  static Future<Color> getLikeColor(Tweet tweet) async {
    return await TwitterAPI().isLiked(tweet.id_str) ? Colors.red : Colors.white;
  }

  static Future<Color> getRetweetColor(Tweet tweet) async {
    // return await TwitterAPI().isLiked(tweet.id_str) ? Colors.red : Colors.white;
    return Colors.white;
  }

  static Future<Color> getBookmarkColor(Tweet tweet) async {
    // return await TwitterAPI().isLiked(tweet.id_str) ? Colors.red : Colors.white;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: model.issueTweetKey(tweet.id),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.network(tweet.user.profile_image_url_https),
          Flexible(
            child: Column(
              children: [
                Text(tweet.user.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                tweet.getTweetContent(context),
                SizedBox(
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Consumer<HomeModel>(
                          builder: (_, __, ___) {
                            return Row(
                              children: [
                                Icon(Icons.comment, color: Colors.white),
                                Text("10"),
                              ],
                            );
                          },
                        ),
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
                            return Row(
                              children: [
                                FutureBuilder(
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
                                ),
                                Text("10"),
                              ],
                            );
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Consumer<HomeModel>(
                          builder: (_, __, ___) {
                            return Row(
                              children: [
                                FutureBuilder(
                                  future: TweetWidget.getRetweetColor(tweet),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<Color> snapshot) {
                                    if (snapshot.hasData) {
                                      return Icon(Icons.loop,
                                          color: snapshot.data);
                                    } else {
                                      return Icon(Icons.loop);
                                    }
                                  },
                                ),
                                Text("10"),
                              ],
                            );
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Consumer<HomeModel>(
                          builder: (_, __, ___) {
                            return Row(
                              children: [
                                FutureBuilder(
                                  future: TweetWidget.getBookmarkColor(tweet),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<Color> snapshot) {
                                    if (snapshot.hasData) {
                                      return Icon(Icons.bookmark_border,
                                          color: snapshot.data);
                                    } else {
                                      return Icon(Icons.bookmark_border);
                                    }
                                  },
                                ),
                                Text("10"),
                              ],
                            );
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
