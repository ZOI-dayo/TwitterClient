// https://developer.twitter.com/en/docs/twitter-api/v1/data-dictionary/object-model/user

import 'dart:ffi';

import 'package:fixnum/fixnum.dart';

class User {
  late final Int64 id;
  late final String id_str;
  late final String name;
  late final String screen_name;
  late final String location;
  late final String url;
  late final String description;
  late final bool protected;
  late final bool verified;
  late final int followers_count;
  late final int friends_count;
  late final int listed_count;
  late final int favourites_count;
  late final int statuses_count;
  late final String created_at;
  late final String profile_banner_url;
  late final String profile_image_url_https;
  late final bool default_profile;
  late final bool default_profile_image;
  late final List<String> withheld_in_countries;
  late final String withheld_scope;
  User(Map userObject) {
    name = userObject["name"];
    profile_image_url_https = userObject["profile_image_url_https"];
  }
}