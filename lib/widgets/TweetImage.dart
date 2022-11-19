import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_plugin/tags.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
import 'package:path_provider/path_provider.dart';

import '../twitter_objects/tweet.dart';

class TweetImage extends Container {
  TweetImage(BuildContext context, Tweet tweet, List<String> imageUrls)
      : super(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _getImageContent(context, tweet, imageUrls));

  static Widget? _getImageContent(
      BuildContext context, Tweet tweet, List<String> imageUrls) {
    var clickableImages = imageUrls
        .map((url) => GestureDetector(
            onTap: () {
              onClickImage(context, tweet, url);
            },
            child: Image.network(url + "?name=thumb", fit: BoxFit.contain)))
        .toList();
    switch (clickableImages.length) {
      case 1:
        return clickableImages[0];
      case 2:
        return GridView.count(
          crossAxisCount: 2,
          children: clickableImages,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        );
      case 3:
        return GridView.count(
          crossAxisCount: 2,
          children: [
            clickableImages[0],
            Column(
              children: [clickableImages[1], clickableImages[2]],
            )
          ],
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        );
      case 4:
        return GridView.count(
          crossAxisCount: 2,
          children: clickableImages,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        );
      default:
        return null;
    }
  }

  static void onClickImage(context, Tweet tweet, String url) {
    Navigator.push(context, _ImageDialog(tweet, url));
  }
}

class _ImageDialog extends ModalRoute<void> {
  String url;
  Tweet tweet;

  _ImageDialog(this.tweet, this.url);

  @override
  Color barrierColor = Colors.black45;

  @override
  bool barrierDismissible = true;

  @override
  String barrierLabel = "Twitter Image";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.network(url),
            ),
            Positioned(
              top: 10.0,
              right: 10.0,
              child: PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<_ImageOption>>[
                  const PopupMenuItem(
                    value: _ImageOption.SAVE,
                    child: Text('Save Image'),
                  ),
                ],
                onSelected: (result) {
                  if (result == _ImageOption.SAVE) {
                    print("saving...");
                    _saveImage(tweet, url).then((_) => print("saved"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  createImage(String name, Uint8List data) async {
    Directory tmpDir = await getTemporaryDirectory();
    File tmpFile = await new File(tmpDir.path + "/" + name + ".jpg")
        .create(recursive: true);
    await tmpFile.writeAsBytes(data);
    await GallerySaver.saveImage(tmpFile.path);
  }

  Future<bool> _saveImage(Tweet tweet, String url) async {
    final httpRequest = await http.get(Uri.parse(url + "?name=orig"));
    final httpResponse = httpRequest.bodyBytes;
    Uint8List? imgData;
    if (Platform.isAndroid) {
      final exif = FlutterExif.fromBytes(httpResponse);
      await exif.setAttribute(TAG_IMAGE_DESCRIPTION, "test01");
      await exif.setAttribute(
          TAG_MAKE, "@" + tweet.user.screen_name + " on Twitter");
      await exif.setAttribute(TAG_MODEL, tweet.id_str);
      await exif.setAttribute(TAG_COPYRIGHT, tweet.user.screen_name);
      await exif.saveAttributes();
      imgData = await exif.imageData;
    } else {
      imgData = httpResponse;
    }
    if (imgData == null) return Future.value(false);
    await createImage(tweet.id_str, imgData);
    return Future.value(true);
  }

  @override
  bool maintainState = false;

  @override
  bool opaque = false;

  @override
  Duration transitionDuration = Duration(milliseconds: 500);
}

enum _ImageOption {
  SAVE,
}
