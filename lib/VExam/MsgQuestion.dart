import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/VCommon/DataAllResultsCard.dart';

import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

class MsgMgrQuestion {
// 此文件只应被DataQuestion包含
  Future<List<SubCpsrcds>> getExamByCpsgrpId(String cpsgrpId) async {
    final token = AuthritionState.instance.getToken();
    final uri = 
        Uri.parse("http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/detail?cpsgrpId=$cpsgrpId");
    final response = await http.Client().get(
      uri,
      headers: {"token": token}
    );
    final u8decoded = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(u8decoded);
    final code = decoded['code'];
    final data = decoded['data'];
    final msg = decoded['msg'];
    if (code != 0) throw ('wrong return code');

    DataExamPage dataExamPage = DataExamPage.fromJson(data);
    
    List<SubCpsrcds> subCpsrcds = List.empty(growable: true);

    for(var topic in dataExamPage.topics!) {
      for(var subCpsrcd in topic.subCpsrcds!) {
        subCpsrcd.title = topic.title;
        subCpsrcds.add(subCpsrcd);
      }
    }
    return subCpsrcds;
  }
/*
  // 客户端解析后的数据上传至服务器
  Future<void> postResultToServer(ParsedResultsXf parsedResultsXf) async {
    final client = http.Client();
    final bodyMap = {
      'resJson': parsedResultsXf.toJson(),
      'cpsgrpId': parsedResultsXf.cpsgrpId,
      'suggestedScore': parsedResultsXf.weightedScore
    };
    final token = await AuthritionState.instance.getToken();
    final response = client.post(
      Uri.parse(
          'http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/save_transcript'),
      body: jsonEncode(bodyMap),
      headers: {
        "Content-Type": "application/json",
        'token': token,
      },
      encoding: Encoding.getByName('utf-8'),
    );
    // TODO 上传结果并评测    
    final responseBytes = utf8.decode((await response).bodyBytes);
  }
*/

  // 将语音数据发往服务器并评测
  // 此函数只应被Data调用
  Future<DataOneResultCard> postAndGetResultXf(SubCpsrcds data) async {
  // 指定URI
  final uri = Uri.parse('http://47.101.58.72:8888/corpus-server/api/evaluate/v1/eval_xf');
  // 指定Request类型
  var request = http.MultipartRequest('POST', uri);
  // 添加文件
  request.files.add(await data.getMultiPartFileAudio());
  // 添加Fields
  request.fields['refText'] = data.toSingleString();
  //data.toSingleString();
  request.fields['category'] = getXfCategoryStringByInt(data.evalMode ?? -1);
  // 设置Headers
  request.headers['Content-Type'] = 'multipart/form-data';
  request.fields['cpsrcdId'] = data.id.toString();
  
  // 发送 并等待返回
  // -----------------------------------------
  final response = await request.send();
  // 将返回转换为字节流, 并解码
  final decoded = jsonDecode(utf8.decode(await response.stream.toBytes()));
  // 处理解码后的数据
  // final resultDataXf =
  //     DataResultXf(evalMode: data.evalMode, weight: data.getWeight());
  // resultDataXf.parseJson(decoded['data']);
  // return resultDataXf;

  final dataOneResultCard = DataOneResultCard();
  dataOneResultCard.evalMode = data.evalMode;
  dataOneResultCard.weight = data.getWeight();
  int less = 0, more = 0, retro = 0, repl = 0;
  var _d = decoded['data']['rec_paper'];
  dynamic d;
  List<DataOneWordCard> oneWordList = List.empty(growable: true);
  switch (data.evalMode) {
    case 2: // read_word
      d = _d['read_word'];
      break;
    case 3: // read_sentence
      d = _d['read_sentence'];
      break;
    case 4: // read_chapter
      d = _d['read_chapter'];
      break;
    default: // read_syllable
      d = _d['read_syllable'];
      break;
  }
  print(d);
  if(true) { // 用于缩略代码
    var sentences = d['sentence'];
    for(var sentence in sentences) {
      var words = sentence['word']['syll'];
      for(var word in words) {
        if(word['content'] == 'sil' || word['content'] == 'silv' || word['content'] == 'fil') continue;
        DataOneWordCard tmp = DataOneWordCard();
        tmp.word = word['content'];
        tmp.pinyin = word['symbol'];
        tmp.isWrong = false;
        tmp.wrongShengMu = false;
        tmp.wrongYunMu = false;
        tmp.wrongShengDiao = false;
        tmp.shengMu = "";
        tmp.yunMu = "";
        tmp.shengDiao = "";
        if(word['dp_message'] == 0) {}
        else if(word['dp_message'] == 16) { less += 1; }
        else if(word['dp_message'] == 32) { more += 1; }
        else if(word['dp_message'] == 64) { retro += 1; }
        else if(word['dp_message'] == 128) { repl += 1; }
        bool f = true;
        var phones = word['phone'];
        for(var phone in phones) {
          if(phone['is_yun'] > 0) {
            tmp.yunMu = phone['content'];
            tmp.shengDiao = phone['mono_tone'];
            switch (phone['perr_msg']) {
              case 1:
                tmp.wrongYunMu = false;
                tmp.wrongShengDiao = true;
                break;
              case 2:
                tmp.wrongYunMu = true;
                tmp.wrongShengDiao = false;
                break;
              default:
                tmp.wrongYunMu = false;
                tmp.wrongShengDiao = false;
                break;                    
            }
          } else {
            tmp.shengMu = phone['content'];
            switch (phone['perr_msg']) {
              case 1:
                tmp.wrongShengMu = false;
                break;
              case 2:
                tmp.wrongShengMu = true;
                break;
              default:
                tmp.wrongShengMu = false;
                break;                    
            }
          }
          if(phone['perr_msg'] > 0) f = false;
        }
        tmp.isWrong = f;
        oneWordList.add(tmp);
      }
    }}
  dataOneResultCard.totalScore = d['totalScore'];
  dataOneResultCard.phoneScore = d['phoneScore'];
  dataOneResultCard.toneScore = d['toneScore'];
  dataOneResultCard.less = less;
  dataOneResultCard.more = more;
  dataOneResultCard.retro = retro;
  dataOneResultCard.repl = repl;
  dataOneResultCard.dataOneWordCard = oneWordList;
  return dataOneResultCard;
}
}