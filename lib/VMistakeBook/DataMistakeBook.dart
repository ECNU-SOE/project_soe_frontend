import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

class DataMistakeBook {
  final int mistakeTotalNumber;
  final int stubbornMistakeNumber;
  final List<DataMistakeBookListItem> listMistakeBookOne;
  final List<DataMistakeBookListItem> listMistakeBookAll;
  DataMistakeBook({
    required this.mistakeTotalNumber,
    required this.stubbornMistakeNumber,
    required this.listMistakeBookOne,
    required this.listMistakeBookAll,
  });
}

class DataMistakeBookListItem {
  final int mistakeNum;
  final String mistakeTypeName;
  final int mistakeTypeCode;
  DataMistakeBookListItem({
    required this.mistakeNum,
    required this.mistakeTypeName,
    required this.mistakeTypeCode,
  });

  factory DataMistakeBookListItem.fromJson(Map<String, dynamic> json) {
    return DataMistakeBookListItem(
      mistakeNum: json['mistakeNum'],
      mistakeTypeCode: json['mistakeTypeCode'],
      mistakeTypeName: json['mistakeTypeName'],
    );
  }
}

Future<DataMistakeBook> getGetDataMistakeBook() async {
  final token = AuthritionState.instance.getToken();
  final uri = Uri.parse(
      "http://47.101.58.72:8888/corpus-server/api/mistake/v1/getDetail?oneWeekKey=0");
  final response = await http.Client().get(
    uri,
    headers: {
      'token': token,
      'Content-Type': 'application/json'
    },
  );
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  // COMMENT-8-12 服务器上目前没有我们测试账号的错题数据, 这是用来测试的临时数据, 不用注释掉即可. 不必删除
  // final decoded = jsonDecode(
  //     '{ "code": 0, "data": {"eachMistakeTypeNumber": [{"mistakeNum": 3,"mistakeTypeName": "字词训练","mistakeTypeCode": 0},{"mistakeNum": 3,"mistakeTypeName": "常速朗读","mistakeTypeCode": 1}],"mistakeTotalNumber": 3,"stubbornMistakeNumber": 1},"msg": null}');
  final code = decoded['code'];
  final data = decoded['data'];
  if (code != 0) throw ("wrong return code");
  final mistakeBookListItem = data['eachMistakeTypeNumber'];
  List<DataMistakeBookListItem> listMistakeBookOne = List.empty(growable: true);
  for (final mistake in mistakeBookListItem) {
    listMistakeBookOne.add(DataMistakeBookListItem.fromJson(mistake));
  }

  final _uri = Uri.parse(
      "http://47.101.58.72:8888/corpus-server/api/mistake/v1/getDetail?oneWeekKey=1");
  final _response = await http.Client().get(
    _uri,
    headers: {
      'token': token,
    },
  );
  final _u8decoded = utf8.decode(_response.bodyBytes);
  final _decoded = jsonDecode(_u8decoded);
  final _code = _decoded['code'];
  final _data = _decoded['data'];
  if (_code != 0) throw ("wrong return code");
  final _mistakeBookListItem = _data['eachMistakeTypeNumber'];
  List<DataMistakeBookListItem> listMistakeBookAll = List.empty(growable: true);
  for (final mistake in _mistakeBookListItem) {
    listMistakeBookAll.add(DataMistakeBookListItem.fromJson(mistake));
  }

  return DataMistakeBook(
      mistakeTotalNumber: data['mistakeTotalNumber'],
      stubbornMistakeNumber: data['stubbornMistakeNumber'],
      listMistakeBookOne: listMistakeBookOne,
      listMistakeBookAll: listMistakeBookAll);
}

class DataMistakeDetail {
  List<DataMistakeDetailListItem> listMistakeDetail;
  DataMistakeDetail({required this.listMistakeDetail});
}

class DataMistakeDetailListItem {
  String cpsrcdId; //题目的快照id，为了识别用户答的是哪道题，答题时给后端传答题结果时需要带上它
  String corpusId;
  String cpsgrpId;
  String topicId;
  int evalMode;
  int difficulty;
  double wordWeight;
  String pinyin;
  String refText;
  String audioUrl;
  String tags;
  int cNum;
  DataMistakeDetailListItem(
      {required this.cpsrcdId,
      required this.corpusId,
      required this.cpsgrpId,
      required this.topicId,
      required this.evalMode,
      required this.difficulty,
      required this.wordWeight,
      required this.pinyin,
      required this.refText,
      required this.audioUrl,
      required this.tags,
      required this.cNum});
  factory DataMistakeDetailListItem.fromJson(Map<String, dynamic> json) {
    return DataMistakeDetailListItem(
        cpsrcdId: json['cpsrcdId'].toString() ?? "",
        corpusId: json['corpusId'].toString() ?? "",
        cpsgrpId: json['cpsgrpId'].toString() ?? "",
        topicId: json['topicId'].toString() ?? "",
        evalMode: json['evalMode'] ?? 0,
        difficulty: json['difficulty'] ?? 0,
        wordWeight: json['wordWeight'] ?? 0.0,
        pinyin: json['pinyin'].toString() ?? "",
        refText: json['refText'].toString() ?? "",
        audioUrl: json['audioUrl'].toString() ?? "",
        tags: json['tags'].toString() ?? "",
        cNum: json['cNum'] ?? 0);
  }
}

Future<DataMistakeDetail> postGetDataMistakeDetail(int mistakeTypeCode, int oneWeekKey) async {
  final token = AuthritionState.instance.getToken();
  final uri = Uri.parse(
      'http://47.101.58.72:8888/corpus-server/api/mistake/v1/getMistakes');
  final response = await http.Client().post(
    uri,
    headers: {"token": token, "Content-Type": "application/json"},
    body: jsonEncode({
      "mistakeTypeCode": mistakeTypeCode, //题目类型，0-语音评测
      "oneWeekKey": oneWeekKey //是否获取近一周的错题数据，0-查全部，1-查一周
    }),
    encoding: Encoding.getByName(
      'utf-8',
    ),
  );
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final code = decoded['code'];
  final data = decoded['data'];
  final msg = decoded['msg'];
  if (code != 0) throw ('wrong return code');
  List<DataMistakeDetailListItem> listMistakeDetail =
      List.empty(growable: true);
  for (final item in data) {
    listMistakeDetail.add(DataMistakeDetailListItem.fromJson(item));
  }
  return DataMistakeDetail(listMistakeDetail: listMistakeDetail);
}


Future<DataMistakeDetailListItem> getGetRandomDataMistakeDetail() async {
  final token = AuthritionState.instance.getToken();
  final uri = Uri.parse(
      'http://47.101.58.72:8888/corpus-server/api/corpus/v1/rand');
  final response = await http.Client().get(
    uri,
    headers: {"token": token, "Content-Type": "application/json"},
  );
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final code = decoded['code'];
  final data = decoded['data'];
  final msg = decoded['msg'];
  if (code != 0) throw ('wrong return code');
  // print(data);
  DataMistakeDetailListItem dataMistakeDetailListItem = new DataMistakeDetailListItem(
      cpsrcdId: "",
      corpusId: data['id'].toString() ?? "",
      cpsgrpId: "",
      topicId: "",
      evalMode: data['evalMode'] ?? 0,
      difficulty: data['difficulty'] ?? 0,
      wordWeight: data['wordWeight'] ?? 0,
      pinyin: data['pinyin'].toString() ?? "",
      refText: data['refText'].toString() ?? "",
      audioUrl: data['audioUrl'].toString() ?? "",
      tags: data['tags'].toString() ?? "",
      cNum: 0
  );
  print(dataMistakeDetailListItem);
  return dataMistakeDetailListItem;
}
