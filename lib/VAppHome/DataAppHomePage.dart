import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

import 'package:http/http.dart' as http;

class DataViewSign {
  bool todaySigned;
  List<DataSignDayInfo> list;
  DataViewSign({required this.list, required this.todaySigned});
}

class DataSignDayInfo {
  int day;
  DataSignDayInfo({
    required this.day,
  });
}

class MsgSign {
  Future<DataViewSign> getViewUserSignInfo(int month, int year) async {
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
      return DataViewSign(list: ret, todaySigned: false);
    }
    if (null == deData['signDates']) {
      return DataViewSign(list: ret, todaySigned: false);
    }
    for (final date in deData['signDates']) {
      DateTime dt = DateTime.parse(date);
      ret.add(DataSignDayInfo(day: dt.day));
    }

    bool t_sign = false;
    final today = DateTime.now();
    final t_uri = Uri.parse(
        "http://47.101.58.72:8888/user-server/api/user/v1/sign_info?year=${today.year}&&month=${today.month}");
    final t_response = await client.get(
      t_uri,
      headers: {
        'token': token,
      },
    );
    final t_decoded = jsonDecode(utf8.decode(t_response.bodyBytes));
    final t_deData = t_decoded['data'];
    for (final t_deDate in t_deData['signDates']) {
      DateTime dt = DateTime.parse(t_deDate);
      if (dt.day == today.day) {
        t_sign = true;
        break;
      }
    }

    return DataViewSign(list: ret, todaySigned: t_sign);
  }

  Future<void> postUserSign() async {
    final client = http.Client();
    final response = await client.get(
      Uri.parse('http://47.101.58.72:8888/user-server/api/user/v1/sign'),
      headers: {
        'token': AuthritionState.instance.getToken(),
      },
    );
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
  }
}
