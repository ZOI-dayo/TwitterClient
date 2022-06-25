import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

import '../globals.dart';
import '../pages/home_model.dart';
import '../pages/timeline_model.dart';
import '../state/timeline.dart';
import '../twitter_objects/tweet.dart';
import '../twitter_api.dart';

class TweetWidget extends StatelessWidget {
  Tweet tweet;

  TweetWidget(this.tweet) : super();

  /*void openTweet(BuildContext context, {Tweet? tweet}) {
    late TweetModel tweetModel;
    if (tweet == null) {
      tweet = context.read<TweetModel>().tweet;
      tweetModel = context.read<TweetModel>();
    } else {
      tweetModel = TweetModel(tweet);
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) {
          return ChangeNotifierProvider<TweetModel>(
            create: (_) => tweetModel,
            child: Material(
              type: MaterialType.canvas,
              child: SafeArea(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 10) {
                      Navigator.pop(context);
                    }
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _getTweetWidget(context, tweet!),
                        _getButtonBar(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final Offset begin = Offset(1.0, 0.0);
          final Offset end = Offset.zero;
          final Animatable<Offset> tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final Animation<Offset> offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //openTweet(context, tweet: context.read<TweetModel>().tweet);
      },
      child: Container(
        key: getIt<TimelineState>().issueTweetKey(tweet.id),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            _getTweetWidget(context, tweet),
            _getButtonBar(context),
          ],
        ),
      ),
    );
  }

  Widget _getTweetWidget(BuildContext context, Tweet tweet) {
    return Row(
      children: [
        Image.network(tweet.user.profile_image_url_https),
        Flexible(
          child: Column(
            children: [
              Text(tweet.user.name,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              if (!tweet.isRetweeted())
                tweet.getTweetContent(context, retweeted: true)
              else
                GestureDetector(
                  onTap: () {
                    //openTweet(context, tweet: tweet.retweeted_status ?? tweet);
                  },
                  child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(10),
                      child: _getTweetWidget(
                          context, tweet.retweeted_status ?? tweet)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // BuildContextでなくTweetを使ってできるようにする
  Widget _getButtonBar(BuildContext context) {
    return SizedBox(
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
              context.watch<TimelineModel>().like(tweet);
            },
            child: Row(
              children: [
                Icon(Icons.favorite,
                    color: context.watch<TimelineModel>().getLikeColor(tweet)),
                Text(tweet
                    .favorite_count
                    .toString()),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.watch<TimelineModel>().retweet(tweet);
            },
            child: Row(
              children: [
                Icon(Icons.loop,
                    color: context.watch<TimelineModel>().getRetweetColor(tweet)),
                Text(
                    tweet.retweet_count.toString()),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.watch<TimelineModel>().share(tweet);
            },
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
    );
  }
}

