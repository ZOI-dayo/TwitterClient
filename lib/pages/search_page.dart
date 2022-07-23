
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../widgets/outlined_button.dart';
import '../widgets/outlined_text_field.dart';
import '../widgets/search_input_field.dart';
import '../widgets/expand_button.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SearchInputField(onSearch:()=>{
                
              }),
            ),
            ExpandButton(
              name: 'フィルタ',
              child: createFilterOption(context),
            )],
        ),
      ),
    );
  }

  Widget createFilterOption(BuildContext context){
    SearchModel searchModel = context.watch<SearchModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('ユーザ:'),
            Flexible(
              child: OutlinedTextField(),
            )
          ],
        ),
        Row(
          children: [
            Text('日付:'),
            OutlinedTextButton(
              text: displayFormat.format(searchModel.fromDate),
              onPressed: () {
                searchModel.selectDate(context, searchModel.fromDate).then((value) => searchModel.setFromDate(value));
              },
            ),
            Text('～'),
            OutlinedTextButton(
              text: displayFormat.format(searchModel.toDate),
              onPressed: () {
                searchModel.selectDate(context, searchModel.toDate).then((value) => searchModel.setToDate(value));
              },
            ),
          ],
        ),
      ],
    );
  }


}
