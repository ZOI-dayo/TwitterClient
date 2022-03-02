import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TweetImage extends Container {
  TweetImage(List<Image> images)
      :super(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _getImageContent(images)
  );

  static Widget? _getImageContent(List<Image> images) {
    switch (images.length) {
      case 1:
        return images[0];
      case 2:
        return GridView.count(
          crossAxisCount: 2,
          children: images,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        );
      case 3:
        return GridView.count(
          crossAxisCount: 2,
          children: [
            images[0],
            Column(
              children: [images[1], images[2]],
            )
          ],
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        );
      case 4:
        return GridView.count(
          crossAxisCount: 2,
          children: images,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        );
      default:
        return null;
    }
  }
}