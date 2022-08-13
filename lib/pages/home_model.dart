import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../state/timeline.dart';
import '../globals.dart';
import 'main_model.dart';

class HomeModel extends ChangeNotifier {

  int selectedTab = 0;
  MainModel? mainModel;

  HomeModel(MainModel model){
    mainModel = model;
  }

  void selectTab(int index){
    if(selectedTab == index && index == 0){
      getIt<TimelineState>().controller.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
    } // Timelineの処理のところに書くべきかも?
    selectedTab = index;
    notifyListeners();
  }
}