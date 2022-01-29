
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'main_model.dart';

class ProfileBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const iconSize = 32.0;
    return IconButton(
        icon: context.read<MainModel>().profile_image().isEmpty
            ? Icon(
          Icons.account_circle,
          size: iconSize,
        )
            : CircleAvatar(
          backgroundImage: NetworkImage(context.read<MainModel>().profile_image()),
          backgroundColor: Colors.transparent,
          radius: iconSize / 2,
        ),
        onPressed: ()=>{}
    );
  }
}