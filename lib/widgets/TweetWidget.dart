import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_test/twitter_api.dart';

import '../globals.dart';
import '../pages/home_page.dart';
import '../pages/home_model.dart';
import '../state/timeline.dart';
import '../twitter_objects/tweet.dart';

class TweetWidget extends StatelessWidget {
  Tweet tweet;

  TweetWidget(this.tweet) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        open(context);
      },
      child: Container(
        key: tweet.key,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getTweetWidget(context, tweet),
          ],
        ),
      ),
    );
  }

  Widget _getTweetWidget(BuildContext context, Tweet tweet) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            tweet.user.profile_image_url_https,
            errorBuilder: (c, o, s) {
              return const Icon(
                Icons.error,
                color: Colors.red,
              );
            },
          ),
          Flexible(
            child: Column(
              children: [
                Text(tweet.user.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // if (!tweet.isRetweeted())
                  tweet.getTweetContent(context/*, retweeted: true*/),
                // else
                //   GestureDetector(
                //     onTap: () {
                //       open(context);
                //       //openTweet(context, tweet: tweet.retweeted_status ?? tweet);
                //     },
                //     child: Container(
                //         color: Colors.transparent,
                //         padding: EdgeInsets.all(10),
                //         child: _getTweetWidget(
                //             context, tweet.retweeted_status ?? tweet)),
                //   ),
                _getButtonBar(context),
              ],
            ),
          ),
        ],
      ),
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
                _getReply(context, tweet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getReply(BuildContext context, Tweet tweet) {
    return SizedBox(
      height: 500,
      child: ListView.builder(
        itemBuilder: (context, index) {
          TwitterAPI().getReplies(tweet);
          return SizedBox(
            width: 10,
            height: 10,
          );
        },
        itemCount: 1,
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
      height: 100,
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
              builder: (_, __, ___) => Icon(Icons.comment, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              getIt<TimelineState>().like(tweet);
            },
            child: Row(
              children: [
                Icon(Icons.favorite,
                    color: getIt<TimelineState>().getLikeColor(tweet)),
                Text(tweet.favorite_count.toString()),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              getIt<TimelineState>().retweet(tweet);
            },
            child: Row(
              children: [
                Icon(Icons.loop,
                    color:
                    getIt<TimelineState>().getRetweetColor(tweet)),
                Text(tweet.retweet_count.toString()),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              getIt<TimelineState>().share(tweet);
            },
            child: Consumer<HomeModel>(
              builder: (_, __, ___) => Icon(Icons.share),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
