


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpandButton extends StatefulWidget {
  String name;
  Widget? child;
  ExpandButton({required this.name, required this.child});
  @override
  State<ExpandButton> createState() => ExpandButtonState();
}

class ExpandButtonState extends State<ExpandButton> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              expand = !expand;
            });
          },
          child: Row(
            children: [
              Icon(expand?Icons.expand_more:Icons.expand_less),
              Text(widget.name),
            ],
          ),
        ),
        if(widget.child!=null && expand) widget.child!
      ],
    );
  }
}