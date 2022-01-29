import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:twitter_test/pages/message_page.dart';
import 'package:twitter_test/pages/notification_page.dart';

import 'home_model.dart';
import 'profile_bar.dart';
import 'search_page.dart';
import 'timeline_page.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeModel(),
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
        onTap: (int index) => {
          context.read<HomeModel>().selectTab(index)
        },
        currentIndex: context.watch<HomeModel>().selectedTab,
      ),
      body: getCurrentTab(context),
    );
  }

  Widget getCurrentTab(BuildContext context) {
    print('selectTab ${context.read<HomeModel>().selectedTab}');
    switch (context.read<HomeModel>().selectedTab) {
      case 0:return TimelinePage();
      case 1:return SearchPage();
      case 2:return NotificationPage();
      case 3:return MessagePage();
      default:return Text("ERROR");
    }
  }
}
