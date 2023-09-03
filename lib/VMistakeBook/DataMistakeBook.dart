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
  final List<DataMistakeBookListItem> listMistakeBook;
  DataMistakeBook({
    required this.mistakeTotalNumber,
    required this.stubbornMistakeNumber,
    required this.listMistakeBook,
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
  final uri = Uri.parse("http://47.101.58.72:8888/corpus-server/api/mistake/v1/getDetail?oneWeekKey=0");
  final response = await http.Client().get(
    uri,
    headers: {
      'token': token,
    },
  );
  final u8decoded = utf8.decode(response.bodyBytes);
  // final decoded = jsonDecode(u8decoded);
  // COMMENT-8-12 服务器上目前没有我们测试账号的错题数据, 这是用来测试的临时数据, 不用注释掉即可. 不必删除
  final decoded = jsonDecode(
      '{ "code": 0, "data": {"eachMistakeTypeNumber": [{"mistakeNum": 3,"mistakeTypeName": "字词训练","mistakeTypeCode": 0},{"mistakeNum": 3,"mistakeTypeName": "常速朗读","mistakeTypeCode": 1}],"mistakeTotalNumber": 3,"stubbornMistakeNumber": 1},"msg": null}');
  final code = decoded['code'];
  final data = decoded['data'];
  if (code != 0) throw ("wrong return code");
  final mistakeBookListItem = data['eachMistakeTypeNumber'];
  List<DataMistakeBookListItem> listMistakeBook = List.empty(growable: true);
  for (final mistake in mistakeBookListItem) {
    listMistakeBook.add(DataMistakeBookListItem.fromJson(mistake));
  }
  return DataMistakeBook(
    mistakeTotalNumber: data['mistakeTotalNumber'],
    stubbornMistakeNumber: data['stubbornMistakeNumber'],
    listMistakeBook: listMistakeBook);
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
  int wordWeight;
  String pinyin;
  String refText;
  String audioUrl;
  DataMistakeDetailListItem({
    required this.cpsrcdId,
    required this.corpusId,
    required this.cpsgrpId,
    required this.topicId,
    required this.evalMode,
    required this.difficulty,
    required this.wordWeight,
    required this.pinyin,
    required this.refText,
    required this.audioUrl,
  });
  factory DataMistakeDetailListItem.fromJson(Map<String, dynamic> json) {
    return DataMistakeDetailListItem(
      cpsrcdId: json['cpsrcdId'] ?? "",
      corpusId: json['corpusId'] ?? "",
      cpsgrpId: json['cpsgrpId'] ?? "",
      topicId: json['topicId'] ?? "",
      evalMode: json['evalMode'] ?? 0,
      difficulty: json['difficulty'] ?? 0,
      wordWeight: json['wordWeight'] ?? 0,
      pinyin: json['pinyin'] ?? "",
      refText: json['refText'] ?? "",
      audioUrl: json['audioUrl'] ?? "",
    );
  }
}

Future<DataMistakeDetail> postGetDataMistakeDetail(
    int mistakeTypeCode, int oneWeekKey) async {
  final token = AuthritionState.instance.getToken();
  final uri = Uri.parse('http://47.101.58.72:8888/corpus-server/api/mistake/v1/getMistakes');
  final response = await http.Client().post(
    uri,
    headers: {
      "token": token,
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "mistakeTypeCode":mistakeTypeCode, //题目类型，0-语音评测
      "oneWeekKey":oneWeekKey //是否获取近一周的错题数据，0-查全部，1-查一周
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
  // if (code != 0) throw ('wrong return code');
  List<DataMistakeDetailListItem> listMistakeDetail = List.empty(growable: true);
  // for (final item in data) {
  //   listMistakeDetail.add(DataMistakeDetailListItem.fromJson(item));
  // }
  
  listMistakeDetail.add(DataMistakeDetailListItem.fromJson({
      "cpsrcdId": "cpsrcd_1637716290204471296",//题目的快照id，为了识别用户答的是哪道题，答题时给后端传答题结果时需要带上它
      "corpusId": null,
      "cpsgrpId": "cpsgrp_1666820615325224960",//语料组id，错题模块暂时用不到，以后如果要显示该题是哪张试卷上的可能要用到
      "topicId": "topic_1667733584137555968",
      "evalMode": null,
      "difficulty": -1,
      "wordWeight": 0,
      "pinyin": "di4 san1 sheng1 ˇ   di4 er4 sheng1 ˊ \n",
      "refText": "第三声ˇ 第二声ˊ\n",//该题的题干内容
      "audioUrl": "https://soe-oss.oss-cn-shanghai.aliyuncs.com/corpus/2023/06/14/5c1a801c02c740718616df3fa28918ab.MP3",
      "tags": null,
      "cNum": 8 //该题目在语料组里第几题，暂时用不到
  }));
  listMistakeDetail.add(DataMistakeDetailListItem.fromJson({
      "cpsrcdId": "cpsrcd_1637716465396355072",
      "corpusId": null,
      "cpsgrpId": "cpsgrp_1666820615325224960",
      "topicId": "topic_1667734588706918400",
      "evalMode": null,
      "difficulty": -1,
      "wordWeight": 0,
      "pinyin": "di4 yi1 sheng1 + di4 yi1 sheng1     di4 yi1 sheng1 + di4 si4 sheng1   \n",
      "refText": "第一声+第一声  第一声+第四声 \n",
      "audioUrl": "https://soe-oss.oss-cn-shanghai.aliyuncs.com/corpus/2023/06/14/905990689126453a93bde760bdd4506a.MP3",
      "tags": null,
      "cNum": 1
  }));
  listMistakeDetail.add(DataMistakeDetailListItem.fromJson({
      "cpsrcdId": "cpsrcd_1637716759102492672",
      "corpusId": null,
      "cpsgrpId": "cpsgrp_1666820615325224960",
      "topicId": "topic_1667734588706918400",
      "evalMode": null,
      "difficulty": -1,
      "wordWeight": 0,
      "pinyin": "di4 yi1 sheng1 + di4 er4 sheng1 \n di4 er4 sheng1 + di4 er4 sheng1 \n",
      "refText": "第一声+第二声\n第二声+第二声\n",
      "audioUrl": "https://soe-oss.oss-cn-shanghai.aliyuncs.com/corpus/2023/06/14/aa8b1f982c234fd1b8fc634f23b8368e.MP3",
      "tags": null,
      "cNum": 2
  }));
  
  return DataMistakeDetail(listMistakeDetail: listMistakeDetail);
}
