import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TweetImage extends Container {
  TweetImage(BuildContext context, List<String> imageUrls)
      : super(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _getImageContent(context, imageUrls));

  static Widget? _getImageContent(
      BuildContext context, List<String> imageUrls) {
    var clickableImages = imageUrls
        .map((url) => GestureDetector(
            onTap: () {
              onClickImage(context, url);
            },
            child: Image.network(url, fit: BoxFit.contain)))
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

  static void onClickImage(context, String url) {
    Navigator.push(context, _ImageDialog(url));
  }
}

class _ImageDialog extends ModalRoute<void> {
  String url;

  _ImageDialog(this.url) {}

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
                    print("saved");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
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
