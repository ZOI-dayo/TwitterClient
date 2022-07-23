
import 'package:flutter/material.dart';

class OutlinedTextField extends StatefulWidget {
  OutlinedTextField();
  @override
  State<OutlinedTextField> createState() => OutlinedTextFieldState();
}

class OutlinedTextFieldState extends State<OutlinedTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          )),
    );
  }

}