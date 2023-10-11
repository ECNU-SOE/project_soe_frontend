import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VCommon/DataAllResultsCard.dart';
import 'package:project_soe/VExam/DataQuestion.dart';

class DataMistakeBook {
  final int mistakeTotalNumber1;
  final int stubbornMistakeNumber1;
  final int mistakeTotalNumber2;
  final int stubbornMistakeNumber2;
  final List<DataMistakeBookListItem> listMistakeBookOne;
  final List<DataMistakeBookListItem> listMistakeBookAll;
  DataMistakeBook({
    required this.mistakeTotalNumber1,
    required this.stubbornMistakeNumber1,
    required this.mistakeTotalNumber2,
    required this.stubbornMistakeNumber2,
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
      "http://47.101.58.72:8888/corpus-server/api/mistake/v1/getDetail?oneWeekKey=1");
  final response = await http.Client().get(
    uri,
    headers: {'token': token, 'Content-Type': 'application/json'},
  );
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final code = decoded['code'];
  final data = decoded['data'];
  if (code != 0) throw ("wrong return code");
  final mistakeBookListItem = data['eachMistakeTypeNumber'];
  List<DataMistakeBookListItem> listMistakeBookOne = List.empty(growable: true);
  for (final mistake in mistakeBookListItem) {
    listMistakeBookOne.add(DataMistakeBookListItem.fromJson(mistake));
  }

  int x = data['mistakeTotalNumber'];
  int y = data['stubbornMistakeNumber'];

  final _uri = Uri.parse(
      "http://47.101.58.72:8888/corpus-server/api/mistake/v1/getDetail?oneWeekKey=0");
  final _response = await http.Client().get(
    _uri,
    headers: {'token': token, 'Content-Type': 'application/json'},
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
      mistakeTotalNumber1: x,
      stubbornMistakeNumber1: y,
      mistakeTotalNumber2: data['mistakeTotalNumber'],
      stubbornMistakeNumber2: data['stubbornMistakeNumber'],
      listMistakeBookOne: listMistakeBookOne,
      listMistakeBookAll: listMistakeBookAll);
}

Future<List<SubCpsrcds>> postGetDataMistakeDetail(
    int mistakeTypeCode, int oneWeekKey) async {
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
  List<SubCpsrcds> listSubCpsrcds = List.empty(growable: true);
  for (final item in data) {
    SubCpsrcds tmp = SubCpsrcds.fromJson(item);
    tmp.id = item['cpsrcdId'];
    tmp.evalMode = item['evalMode'];
    listSubCpsrcds.add(tmp);
  }
  return listSubCpsrcds;
}

Future<SubCpsrcds> getGetRandomDataMistakeDetail() async {
  final token = AuthritionState.instance.getToken();
  final uri =
      Uri.parse('http://47.101.58.72:8888/corpus-server/api/cpsrcd/v1/rand');
  final response = await http.Client().post(
    uri,
    headers: {"token": token, "Content-Type": "application/json"},
    body: jsonEncode({
      "type": null, //暂不支持
      "difficultyBegin": null, //暂不支持
      "difficultyEnd": null, //暂不支持
      "textValue": null, //暂不支持
      "tagIds": [
        //语料标签   //查询逻辑是输入多个标签时，显示的结果中会包含其中至少一个标签
        2,
        5
      ]
    }),
  );
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final code = decoded['code'];
  final data = decoded['data'];
  final msg = decoded['msg'];
  if (code != 0) throw ('wrong return code');
  print(code);
  // SubCpsrcds subCpsrcds = SubCpsrcds.fromJson(data);
  List<Tags> tags = List.empty(growable: true);
  data['tags'].forEach((v) {
    tags!.add(new Tags.fromJson(v));
  });
  SubCpsrcds subCpsrcds = SubCpsrcds(
    id: data['id'] ?? "",
    topicId: "",
    cpsgrpId: "",
    type: data['type'] ?? "",
    evalMode: data['evalMode'] ?? -1,
    difficulty: data['difficulty'] ?? -1,
    score: 0.0,
    enablePinyin: false,
    pinyin: data['pinyin'] ?? "",
    refText: data['refText'] ?? "",
    audioUrl: data['audioUrl'] ?? "",
    description: "",
    tags: tags,
    gmtCreate: data['gmtCreate'] ?? "",
    gmtModified: data['gmtModified'] ?? "",
    cNum: -1
  );
  return subCpsrcds;
}
