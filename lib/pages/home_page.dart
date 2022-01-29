import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:twitter_test/pages/profile_bar.dart';
import 'package:twitter_test/pages/timeline_model.dart';

class HomePage extends StatelessWidget {

  final likeList = [];
  @override
  Widget build(BuildContext context) {
    context.read<TimelineModel>().tryLoadTimeline(context);
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
          context.read<TimelineModel>().selectTab(index)
        },
        currentIndex: context.read<TimelineModel>().selectedTab,
      ),
      body: Text(""),
    );
  }
}
