import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:project_soe/src/VAuthorition/MsgAuthorition.dart';
import 'package:project_soe/src/VFullExam/DataQuestion.dart';
import 'package:project_soe/src/VAuthorition/LogicAuthorition.dart';

Future<DataClassPageInfo> postGetDataClassInfo() async {
  final token = AuthritionState.get().getToken();
  final client = http.Client();
  final uri = Uri.parse(
      'http://47.101.58.72:8888/user-server/api/course/v1/list_user_cour');
  final userInfo = await MsgAuthorition().getDataUserInfo(token);
  final bodyMap = {'accountNo': userInfo!.accountId};
  final response = await client.post(
    uri,
    body: jsonEncode(bodyMap),
    headers: {
      'token': token,
    },
    encoding: Encoding.getByName('utf-8'),
  );
  final decoded = jsonDecode(utf8.decode(response.bodyBytes))['data'];
  final dataClassPageInfo = DataClassPageInfo();
  return dataClassPageInfo.parseJson(decoded);
}

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
  final token = AuthritionState.get().getToken();
  final client = http.Client();
  final uri = Uri.parse(
      "http://47.101.58.72:8888/user-server/api/course/v1/add_user_cour");
  final userInfo = await MsgAuthorition().getDataUserInfo(token);
  final bodyMap = {'accountNo': userInfo!.accountId, 'courseId': courseId};
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
  parseJson(List<Map<String, dynamic>> jsonList) {
    for (Map<String, dynamic> json in jsonList) {
      pickedCourses.add(DataCourseInfo.fromJson(json));
    }
  }
}

class DataCourseInfo {
  String id;
  String accountNo;
  String courseId;
  int rtype;
  DataCourseInfo({
    required this.id,
    required this.accountNo,
    required this.courseId,
    required this.rtype,
  });
  factory DataCourseInfo.fromJson(Map<String, dynamic> json) {
    return DataCourseInfo(
      id: json['id'],
      accountNo: json['accountNo'],
      courseId: json['courseId'],
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
