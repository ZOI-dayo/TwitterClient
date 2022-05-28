import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

class MainModel extends ChangeNotifier {
  final controller = new TextEditingController();

  MainModel();

  String profile_image(){
    return "";
  }
}