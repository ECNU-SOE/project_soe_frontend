import 'dart:ffi';

import 'package:flutter/material.dart';

class DataSignDayInfo {
  int day;
  DataSignDayInfo({
    required this.day,
  });
}

class MsgSign {
  Future<List<DataSignDayInfo>> getListSignDataInfo(int month, int year) async {
    List<DataSignDayInfo> ret = List.empty(growable: true);
    ret.addAll([DataSignDayInfo(day: 2), DataSignDayInfo(day: 3)]);
    return ret;
  }
}

// class DataAppHomePage {
//   int curMonth;
//   List<DataSignDayInfo> curMonList;
//   DataAppHomePage({
//     required this.curMonth,
//     required this.curMonList,
//   });
// }
