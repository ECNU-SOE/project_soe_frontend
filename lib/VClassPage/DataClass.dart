import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:project_soe/VAuthorition/MsgAuthorition.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

// 获取课堂页面数据 (用户选课列表)
Future<DataClassPageInfo> postGetDataClassInfo() async {
  // if (kDebugMode) {
  //   final classPageInfo = DataClassPageInfo();
  //   final json = jsonDecode(
  //           '{"code": 0,"data": [    {      "id": 3,      "accountNo": "user_1587422999043248128",      "classId": "1",      "gmtCreate": "2023-03-19T06:58:56.000+00:00",      "gmtModified": "2023-03-19T06:58:56.000+00:00",      "rtype": 3    },    {      "id": 5,      "accountNo": "user_1587422999043248128",      "classId": "2",      "gmtCreate": "2023-03-24T13:07:07.000+00:00",      "gmtModified": "2023-03-24T13:07:07.000+00:00",      "rtype": 3    },    {      "id": 24,      "accountNo": "user_1587422999043248128",      "classId": "class_1645342954912616448",      "gmtCreate": "2023-04-12T13:49:45.000+00:00",      "gmtModified": "2023-04-12T13:49:45.000+00:00",      "rtype": 4    }  ],  "msg": null}')[
  //       'data'];
  //   classPageInfo.parseJson(json);
  //   return classPageInfo;
  // }
  final hasLoggedIn = AuthritionState.instance.hasToken();
  if (!hasLoggedIn) return DataClassPageInfo();
  final token = AuthritionState.instance.getToken();
  final client = http.Client();
  final uri = Uri.parse(
      'http://47.101.58.72:8888/user-server/api/class/v1/list_usr_class');
  // final userInfo = await MsgAuthorition().getDataUserInfo(token);
  // final bodyMap = {
  // 'accountNo': userInfo!.accountId
  // };
  final response = await client.post(
    uri,
    body: jsonEncode({}),
    headers: {
      'token': token,
      "Content-Type": "application/json",
    },
    encoding: Encoding.getByName('utf-8'),
  );
  final decoded = jsonDecode(utf8.decode(response.bodyBytes));
  final decodedJson = decoded['data'];
  final dataClassPageInfo = DataClassPageInfo();
  if (decodedJson != null) {
    dataClassPageInfo.parseJson(decodedJson);
  }
  return dataClassPageInfo;
}

// 获取某一课堂的数据 (作业列表)
Future<List<DataHomeworkInfo>> postGetHomeworkInfoList(String courseId) async {
  final uri =
      Uri.parse("http://47.101.58.72:8888/user-server/api/course/v1/list_test");
  final client = http.Client();
  final bodyMap = {'courseId': courseId};
  final response = await client.post(
    uri,
    body: jsonEncode(bodyMap),
    encoding: Encoding.getByName('utf-8'),
  );
  List<DataHomeworkInfo> list = List.empty(growable: true);
  final decodedList =
      jsonDecode(utf8.decode(response.bodyBytes))['data']['records'];
  for (final item in decodedList) {
    list.add(DataHomeworkInfo.formJson(item));
  }
  return list;
}

Future<void> postAddUserCourseInfo(int courseId) async {
  final token = AuthritionState.instance.getToken();
  final client = http.Client();
  final uri = Uri.parse(
      "http://47.101.58.72:8888/user-server/api/course/v1/add_user_cour");
  final userInfo = await AuthritionState.instance.getUserInfo();
  final bodyMap = {'accountNo': userInfo.accountId, 'courseId': courseId};
  final response = await client.post(
    uri,
    body: jsonEncode(bodyMap),
    headers: {
      'token': token,
    },
    encoding: Encoding.getByName('utf-8'),
  );
}

class DataClassPageInfo {
  List<DataCourseInfo> pickedCourses = List.empty(growable: true);
  DataClassPageInfo();
  parseJson(List<dynamic> jsonList) {
    for (Map<String, dynamic> json in jsonList) {
      pickedCourses.add(DataCourseInfo.fromJson(json));
    }
  }
}

class DataCourseInfo {
  int id;
  String accountNo;
  String classId;
  int rtype;
  DataCourseInfo({
    required this.id,
    required this.accountNo,
    required this.classId,
    required this.rtype,
  });
  factory DataCourseInfo.fromJson(Map<String, dynamic> json) {
    return DataCourseInfo(
      id: json['id'],
      accountNo: json['accountNo'],
      classId: json['classId'],
      rtype: json['rtype'] as int,
    );
  }
}

class DataHomeworkInfo {
  String courseId;
  String title;
  String desc;
  int type;
  // int difficulty;
  // bool public;
  DateTime startTime;
  DateTime endTime;
  String cpsgrpId;
  DataHomeworkInfo({
    required this.courseId,
    required this.title,
    required this.desc,
    required this.type,
    // required this.difficulty,
    // required this.public,
    required this.startTime,
    required this.endTime,
    required this.cpsgrpId,
  });
  factory DataHomeworkInfo.formJson(Map<String, dynamic> json) {
    return DataHomeworkInfo(
      cpsgrpId: json['id'],
      courseId: json['courseId'],
      title: json['title'],
      desc: json['description'],
      type: json['type'] as int,
      // difficulty: json['difficulty'],
      // public: json['public'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }
}
