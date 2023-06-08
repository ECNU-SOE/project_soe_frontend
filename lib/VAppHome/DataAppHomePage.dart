import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

import 'package:http/http.dart' as http;

class DataSignDayInfo {
  int day;
  DataSignDayInfo({
    required this.day,
  });
}

class MsgSign {
  Future<List<DataSignDayInfo>> getListSignDataInfo(int month, int year) async {
    final token = AuthritionState.instance.getToken();
    final client = http.Client();
    final uri = Uri.parse(
        "http://47.101.58.72:8888/user-server/api/user/v1/sign_info?year=${year}&&month=${month}");
    final response = await client.get(
      uri,
      headers: {
        'token': token,
      },
    );
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    final deData = decoded['data'];
    List<DataSignDayInfo> ret = List.empty(growable: true);
    if ('用户暂无签到记录' == deData) {
      return ret;
    }
    if (null == deData['signDates']) {
      return ret;
    }
    for (final date in deData['signDates']) {
      DateTime dt = DateTime.parse(date);
      ret.add(DataSignDayInfo(day: dt.day));
    }
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
