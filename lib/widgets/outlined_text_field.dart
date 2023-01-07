
import 'package:flutter/material.dart';

class OutlinedTextField extends StatefulWidget {
  TextEditingController controller;
  OutlinedTextField(this.controller);
  @override
  State<OutlinedTextField> createState() => OutlinedTextFieldState();
}

class OutlinedTextFieldState extends State<OutlinedTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          )),
    );
  }

}