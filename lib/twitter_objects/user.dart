// https://developer.twitter.com/en/docs/twitter-api/v1/data-dictionary/object-model/user

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
    // id = userObject["id"];
    // id_str = userObject["id_str"];
    name = userObject["name"];
    screen_name = userObject["screen_name"];
    // location = userObject["location"];
    // url = userObject["url"];
    // description = userObject["description"];
    // protected = userObject["protected"];
    // verified = userObject["verified"];
    // followers_count = userObject["followers_count"];
    // friends_count = userObject["friends_count"];
    // listed_count = userObject["listed_count"];
    // favourites_count = userObject["favourites_count"];
    // statuses_count = userObject["statuses_count"];
    // created_at = userObject["created_at"];
    // profile_banner_url = userObject["profile_banner_url"];
    profile_image_url_https = userObject["profile_image_url_https"];
    // default_profile = userObject["default_profile"];
    // default_profile_image = userObject["default_profile_image"];
    // withheld_in_countries = userObject["withheld_in_countries"];
    // withheld_scope = userObject["withheld_scope"];
  }
}
