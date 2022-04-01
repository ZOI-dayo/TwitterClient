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

  static Color getLikeColor(Tweet tweet) {
    return tweet.favorited || TwitterAPI().likes.contains(tweet.id_str) ? Colors.red : Colors.white;
  }

  static Color getRetweetColor(Tweet tweet)  {
    return tweet.retweeted || TwitterAPI().retweets.contains(tweet.id_str) ? Colors.red : Colors.white;
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
                          TwitterAPI().like(tweet);
                          TwitterAPI()
                              .updateTweet(tweet)
                              .then((newTweet) => this.tweet = newTweet);
                          model.notifyListeners();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.favorite, color: TweetWidget.getLikeColor(tweet)),
                            Text(tweet.favorite_count.toString()),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          TwitterAPI().retweet(tweet);
                          TwitterAPI()
                              .updateTweet(tweet)
                              .then((newTweet) => this.tweet = newTweet);
                          model.notifyListeners();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.loop, color: TweetWidget.getRetweetColor(tweet)),
                            Text(tweet.retweet_count.toString()),
                          ],
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
                              children: [Icon(Icons.share)],
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
