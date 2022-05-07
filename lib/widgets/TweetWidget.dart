import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

import '../pages/home_model.dart';
import '../twitter_objects/tweet.dart';
import '../twitter_api.dart';

class TweetWidget extends StatelessWidget {
  HomeModel homeModel;

  TweetWidget(this.homeModel) : super();

  void openTweet(BuildContext context, {Tweet? tweet}) {
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openTweet(context, tweet: context.read<TweetModel>().tweet);
      },
      child: Container(
        key: homeModel.issueTweetKey(context.watch<TweetModel>().tweet.id),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            _getTweetWidget(context, context.read<TweetModel>().tweet),
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
                tweet.getTweetContent(context)
              else
                GestureDetector(
                  onTap: () {
                    openTweet(context, tweet: tweet.retweeted_status ?? tweet);
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
              context.read<TweetModel>().like();
            },
            child: Row(
              children: [
                Icon(Icons.favorite,
                    color: context.watch<TweetModel>().getLikeColor()),
                Text(context
                    .watch<TweetModel>()
                    .tweet
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
              context.read<TweetModel>().retweet();
            },
            child: Row(
              children: [
                Icon(Icons.loop,
                    color: context.watch<TweetModel>().getRetweetColor()),
                Text(
                    context.watch<TweetModel>().tweet.retweet_count.toString()),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TweetModel>().share();
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

class TweetModel extends ChangeNotifier {
  Tweet tweet;

  TweetModel(this.tweet);

  void like() {
    TwitterAPI().like(tweet);
    notifyListeners();
  }

  void retweet() {
    TwitterAPI().retweet(tweet);
    notifyListeners();
  }

  void share() {
    ShareExtend.share(tweet.text, "text");
  }

  Color getLikeColor() {
    return tweet.favorited || TwitterAPI().likes.contains(tweet.id_str)
        ? Colors.red
        : Colors.white;
  }

  Color getRetweetColor() {
    return tweet.retweeted || TwitterAPI().retweets.contains(tweet.id_str)
        ? Colors.red
        : Colors.white;
  }
}
