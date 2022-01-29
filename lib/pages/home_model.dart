
import 'package:flutter/widgets.dart';

class HomeModel extends ChangeNotifier {

  int selectedTab = 0;


  void selectTab(int index){
    selectedTab = index;
    notifyListeners();
  }

}