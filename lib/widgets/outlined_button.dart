import 'package:flutter/material.dart';

class OutlinedTextButton extends StatefulWidget {
  String text;
  VoidCallback onPressed;
  OutlinedTextButton({required this.text, required this.onPressed,});
  @override
  State<OutlinedTextButton> createState() => OutlinedTextButtonState();
}

class OutlinedTextButtonState extends State<OutlinedTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
      onPressed: this.widget.onPressed,
      child: Text(this.widget.text),
    );
  }

}