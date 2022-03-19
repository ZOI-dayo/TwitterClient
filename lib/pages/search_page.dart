
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'search_model.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchModel(),
      child: MaterialApp(
        home: _SearchPage(),
      ),
    );
  }
}

class _SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchTextField(),
          ),
          Text('search')],
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              hintText: 'Enter a search term'
            ),
          ),
        ),
        IconButton(onPressed: (){}, icon: Image.asset('assets/icons/ic_send.png'))
      ],
    );
  }
  
}
