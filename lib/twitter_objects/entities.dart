// https://developer.twitter.com/en/docs/twitter-api/v1/data-dictionary/object-model/entities

class Entities {
  final List<Hashtag> hashtags = [];
  final List<Media> media = [];
  final List<Url> urls = [];
  final List<UserMention> user_mentions = [];
  final List<Symbol> symbols = [];
  final List<Poll> polls = [];

  Entities(Map<String, dynamic> srcObject) {
    // TODO: null時処理中断
    if (srcObject.containsKey("hashtags")) {
      for(final tag in srcObject["hashtags"]){
        hashtags.add(new Hashtag(tag));
      }
    }
    if (srcObject.containsKey("media")) {
      for(final m in srcObject["media"]){
        media.add(new Media(m));
      }
    }
    if (srcObject.containsKey("urls")) {
      for(final url in srcObject["urls"]){
        urls.add(new Url(url));
      }
    }
    if (srcObject.containsKey("user_mentions")) {
      for(final mention in srcObject["user_mentions"]){
        user_mentions.add(new UserMention(mention));
      }
    }
    if (srcObject.containsKey("symbols")) {
      for(final symbol in srcObject["symbols"]){
        symbols.add(new Symbol(symbol));
      }
    }
    if (srcObject.containsKey("polls")) {
      for(final poll in srcObject["polls"]){
        polls.add(new Poll(poll));
      }
    }
  }
}

class Hashtag {
  late final List<num> indices;
  late final String text;

  Hashtag(Map<String, dynamic> srcObject) {
    indices = srcObject["indices"].cast<int>();
    text = srcObject["text"] as String;
  }
}

class Media {
  late final String display_url;
  late final String expanded_url;
  late final int id;
  late final String id_str;
  final List<int> indices = [];
  late final String media_url;
  late final String media_url_https;
  late final Sizes sizes;
  late final int? source_status_id;
  late final String? source_status_id_str;
  late final String type;
  late final String url;

  Media(Map<String, dynamic> srcObject) {
    display_url = srcObject["display_url"] as String;
    expanded_url = srcObject["expanded_url"] as String;
    id = srcObject["id"] as int;
    id_str = srcObject["id_str"] as String;
    if (srcObject.containsKey("indices")) {
      for(final indice in srcObject["indices"]){
        indices.add(indice as int);
      }
    }
    media_url = srcObject["media_url"] as String;
    media_url_https = srcObject["media_url_https"] as String;
    sizes = new Sizes(srcObject["sizes"] as Map<String, dynamic>);
    source_status_id = srcObject["source_status_id"];
    source_status_id_str = srcObject["source_status_id_str"];
    type = srcObject["type"] as String;
    url = srcObject["url"] as String;
  }
}

class Sizes {
  late final Size thumb;
  late final Size large;
  late final Size medium;
  late final Size small;

  Sizes(Map<String, dynamic> srcObject) {
    thumb = new Size(srcObject["thumb"] as Map<String, dynamic>);
    large = new Size(srcObject["large"] as Map<String, dynamic>);
    medium = new Size(srcObject["medium"] as Map<String, dynamic>);
    small = new Size(srcObject["small"] as Map<String, dynamic>);
  }
}

class Size {
  late final int w;
  late final int h;
  late final String resize;

  Size(Map<String, dynamic> srcObject) {
    w = srcObject["w"] as int;
    h = srcObject["h"] as int;
    resize = srcObject["resize"] as String;
  }
}

class Url {
  late final String display_url;
  late final String expanded_url;
  late final List<int> indices;
  late final String url;

  Url(Map<String, dynamic> srcObject) {
    display_url = srcObject["display_url"] as String;
    expanded_url = srcObject["expanded_url"] as String;
    indices = srcObject["indices"].cast<int>();
    url = srcObject["url"] as String;
  }
}

class UserMention {
  late final int id;
  late final String id_str;
  late final List<int> indices;
  late final String name;
  late final String screen_name;

  UserMention(Map<String, dynamic> srcObject) {
    id = srcObject["id"] as int;
    id_str = srcObject["id_str"] as String;
    indices = srcObject["indices"].cast<int>();
    name = srcObject["name"] as String;
    screen_name = srcObject["screen_name"] as String;
  }
}

class Symbol {
  late final List<int> indices;
  late final String text;

  Symbol(Map<String, dynamic> srcObject) {
    indices = srcObject["indices"].cast<int>();
    text = srcObject["text"] as String;
  }
}

class Poll {
  late final List<Object> options; // List<Option>
  late final String end_datetime;
  late final String duration_minutes;

  Poll(Map<String, dynamic> srcObject) {
    options = srcObject["options"] as List<Object>;
    end_datetime = srcObject["end_datetime"] as String;
    duration_minutes = srcObject["duration_minutes"] as String;
  }
}
