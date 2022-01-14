import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:twitter_test/pages/timeline_model.dart';

class TimelinePage extends StatelessWidget {

  Widget _buildProfileIconButton(BuildContext context){
    const iconSize = 32.0;
    return IconButton(
      icon: context.read<TimelineModel>().profile_image().isEmpty
          ? Icon(
        Icons.account_circle,
        size: iconSize,
      )
          : CircleAvatar(
        backgroundImage: NetworkImage(context.read<TimelineModel>().profile_image()),
        backgroundColor: Colors.transparent,
        radius: iconSize / 2,
      ),
      onPressed: ()=>{}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Twitter Client'),
        leading: _buildProfileIconButton(context),
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
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
                onRefresh: () async { context.read<TimelineModel>().getTimeline(context); },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: context.watch<TimelineModel>().Count(context),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // color: Color.fromARGB(255, 255, 255, 0),
                        child: Row(children: [
                          // Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                          Image.network(context
                              .watch<TimelineModel>()
                              .tweets
                              .elementAt(index)
                              .user
                              .profile_image_url_https),
                          Flexible(
                              child: Column(
                            children: [
                              Text(
                                  context
                                      .watch<TimelineModel>()
                                      .tweets
                                      .elementAt(index)
                                      .user
                                      .name,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              context
                                  .watch<TimelineModel>()
                                  .tweets
                                  .elementAt(index)
                                  .getTweetContent()
                            ],
                          ))
                        ]),
                      );
                    },
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
