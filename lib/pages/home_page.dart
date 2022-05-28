import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:twitter_test/pages/message_page.dart';
import 'package:twitter_test/pages/notification_page.dart';

import '../state/local.dart';
import '../state/timeline.dart';
import '../twitter_api.dart';
import 'home_model.dart';
import 'main_model.dart';
import 'profile_bar.dart';
import 'search_page.dart';
import 'timeline_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          HomeModel(Provider.of<MainModel>(context, listen: false)),
      child: MaterialApp(
        home: _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  final likeList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Twitter Client'),
        leading: ProfileBar(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.festival),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.light),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
        ],
        onTap: (int index) => {context.read<HomeModel>().selectTab(index)},
        currentIndex: context.watch<HomeModel>().selectedTab,
      ),
      body: getCurrentTab(context),
      floatingActionButton: getIt<TimelineState>().showTweet
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return TweetSheet();
                  },
                );
              },
            )
          : null,
    );
  }

  Widget getCurrentTab(BuildContext context) {
    print('selectTab ${context.read<HomeModel>().selectedTab}');
    switch (context.read<HomeModel>().selectedTab) {
      case 0:
        return TimelinePage();
      case 1:
        return SearchPage();
      case 2:
        return NotificationPage();
      case 3:
        return MessagePage();
      default:
        return Text("ERROR");
    }
  }
}
class TweetSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TweetSheet();
  }

}

class _TweetSheet extends State<StatefulWidget> {
  final TextEditingController _textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 10,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'いまどうしてる？'),
              controller: _textEditingController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () => {}, icon: Icon(Icons.add_rounded)),
                IconButton(onPressed: () {
                  TwitterAPI().tweet(_textEditingController.text);
                  _textEditingController.clear();
                }, icon: Icon(Icons.send)),
              ],
            )
          ],
        ));
  }
}
