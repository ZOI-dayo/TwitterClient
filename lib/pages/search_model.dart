
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateFormat displayFormat = DateFormat('yyyy/MM/dd');
class SearchModel extends ChangeNotifier {
  DateTime fromDate = new DateTime.now();
  DateTime toDate = new DateTime.now();

  Future<DateTime?> selectDate(BuildContext context, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360))
    );
    return picked;
  }

  void setFromDate(DateTime? d){
    if(d!=null) {
      this.fromDate = d;
      notifyListeners();
    }
  }

  void setToDate(DateTime? d){
    if(d!=null) {
      this.toDate = d;
      notifyListeners();
    }
  }

}