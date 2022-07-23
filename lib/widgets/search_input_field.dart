
import 'package:flutter/material.dart';

import 'outlined_text_field.dart';

class SearchInputField extends StatefulWidget {
  VoidCallback onSearch;
  SearchInputField({required this.onSearch});
  @override
  State<SearchInputField> createState() => SearchInputFieldState();

}


class SearchInputFieldState extends State<SearchInputField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: OutlinedTextField()),
        IconButton(
            padding: EdgeInsets.zero,
            onPressed: widget.onSearch, icon: const Icon(Icons.search))
      ],
    );
  }
}