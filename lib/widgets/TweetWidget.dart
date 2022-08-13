import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home_page.dart';
import '../pages/home_model.dart';
import '../pages/timeline_model.dart';
import '../twitter_objects/tweet.dart';

class TweetWidget extends StatelessWidget {
  Tweet tweet;

  TweetWidget(this.tweet) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        open(context);
        //openTweet(context, tweet: context.read<TweetModel>().tweet);
      },
      child: Container(
        key: tweet.key,
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
                    open(context);
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

  Widget _getTweetPage(BuildContext context) {
    return Material(
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
                _getTweetWidget(context, tweet),
                _getButtonBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  open(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) {
          return _getTweetPage(context);
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
  }

  // TODO BuildContextでなくTweetを使ってできるようにする
  Widget _getButtonBar(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return TweetSheet(replyId: tweet.id_str);
                },
              );
            },
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
              context.read<TimelineModel>().like(tweet);
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
              context.read<TimelineModel>().retweet(tweet);
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
              context.read<TimelineModel>().share(tweet);
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

