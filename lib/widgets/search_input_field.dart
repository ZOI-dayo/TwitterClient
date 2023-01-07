import 'package:flutter/material.dart';

import 'outlined_text_field.dart';

typedef TextSubmitCallback = void Function(String text);

class SearchInputField extends StatefulWidget {
  TextSubmitCallback onSearch;
  SearchInputField({required this.onSearch});
  @override
  State<SearchInputField> createState() => SearchInputFieldState();
}

class SearchInputFieldState extends State<SearchInputField> {
  final controler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: OutlinedTextField(controler)),
        IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              widget.onSearch(controler.text);
            },
            icon: const Icon(Icons.search))
      ],
    );
  }
}
