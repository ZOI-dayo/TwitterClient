import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:twitter_test/my_database.dart';
import '../twitter_api.dart';
import '../twitter_objects/tweet.dart';
import 'main_model.dart';

class HomeModel extends ChangeNotifier {

  int selectedTab = 0;
  MainModel? mainModel;

  HomeModel(MainModel model){
    mainModel = model;
  }

  void selectTab(int index){
    selectedTab = index;
    notifyListeners();
  }
}