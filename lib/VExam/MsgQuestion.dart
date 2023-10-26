import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/VCommon/DataAllResultsCard.dart';

import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

class MsgMgrQuestion {
  Future<ExamResult> getExamByCpsgrpId(String cpsgrpId) async {
    final token = AuthritionState.instance.getToken();
    final uri = Uri.parse(
        "http://47.101.58.72:8888/corpus-server/api/cpsgrp/v1/detail?cpsgrpId=$cpsgrpId");
    final response = await http.Client().get(uri, headers: {"token": token});
    final u8decoded = utf8.decode(response.bodyBytes);
    final decoded = jsonDecode(u8decoded);
    final code = decoded['code'];
    final data = decoded['data'];
    final msg = decoded['msg'];
    if (code != 0) throw ('wrong return code');

    DataExamPage dataExamPage = DataExamPage.fromJson(data);
    double totScore = 0;

    List<SubCpsrcds> subCpsrcds = List.empty(growable: true);
    int nowTNum = 1;
    for (var topic in dataExamPage.topics!) {
      for (var subCpsrcd in topic.subCpsrcds!) {
        totScore += subCpsrcd.score ?? 0.0;
        subCpsrcd.title = topic.title;
        subCpsrcd.tNum = nowTNum;
        subCpsrcds.add(subCpsrcd);
      }
      nowTNum += 1;
    }
    return ExamResult(totScore: totScore, listSubCpsrcd: subCpsrcds);
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

  bool _isJsonList(var json) {
    final ret = json[1];
    if (ret != null) {
      return true;
    } else {
      return false;
    }
  }

  // 将语音数据发往服务器并评测
  // 此函数只应被Data调用
  Future<DataOneResultCard> postAndGetResultXf(
      SubCpsrcds data, bool add2Mis) async {
    final token = AuthritionState.instance.getToken();
    var headers = {'token': token};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://47.101.58.72:8888/corpus-server/api/evaluate/v1/eval_xf'));
    request.fields.addAll({
      'refText': data.refText ?? "",
      'category': getXfCategoryStringByInt(data.evalMode ?? -1),
      'pinyin': data.pinyin ?? "",
      "cpsrcdId": add2Mis ? (data.id ?? "") : "",
    });
    request.files.add(await data.getMultiPartFileAudio());
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    final decoded = jsonDecode(utf8.decode(await response.stream.toBytes()));

    final dataOneResultCard = DataOneResultCard();
    dataOneResultCard.evalMode = data.evalMode;
    dataOneResultCard.weight = data.getWeight();
    int less = 0, more = 0, retro = 0, repl = 0;
    Map<String, dynamic> resultJson = decoded['data']['rec_paper']
        [getXfCategoryStringByInt(data.evalMode ?? -1)];
    List<DataOneWordCard> oneWordList = List.empty(growable: true);
    print(getXfCategoryStringByInt(data.evalMode ?? -1));
    RegExp exp = RegExp(r"[\u4e00-\u9fa5]");
    
    if (_isJsonList(resultJson['sentence'])) {
        for (var sentanceJson in resultJson['sentence']) {
          if (_isJsonList(sentanceJson['word'])) {
            for (var wordJson in sentanceJson['word']) {
              if (_isJsonList(wordJson['syll'])) {
                  for (var syrllJson in wordJson['syll']) {
                    if (syrllJson['content'] == 'silv' ||
                        syrllJson['content'] == 'sil' ||
                        syrllJson['content'] == 'fil' || !exp.hasMatch(syrllJson['content'])) {
                      continue;
                    }
                    DataOneWordCard tmp = DataOneWordCard();
                    tmp.word = syrllJson['content'];
                    tmp.pinyin = syrllJson['symbol'];
                    tmp.isWrong = syrllJson['dp_message'] != 0;
                    tmp.wrongShengMu = false;
                    tmp.wrongYunMu = false;
                    tmp.wrongShengDiao = false;
                    tmp.shengMu = "";
                    tmp.yunMu = "";
                    tmp.shengDiao = "";
                    if (syrllJson['dp_message'] == 0) {
                    } else if (syrllJson['dp_message'] == 16) {
                      less += 1;
                    } else if (syrllJson['dp_message'] == 32) {
                      more += 1;
                    } else if (syrllJson['dp_message'] == 64) {
                      retro += 1;
                    } else if (syrllJson['dp_message'] == 128) {
                      repl += 1;
                    }
                    bool f = true;
                    final phoneJson = syrllJson['phone'];
                    if (_isJsonList(phoneJson)) {
                      for (var phone in phoneJson) {
                        if (phone['is_yun'] == 1) {
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
                        } else if (phone['is_yun'] == 0) {
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
                        if (phone['perr_msg'] != 0) f = false;
                      }
                    } else {
                      var phone = phoneJson;
                      if (phone['is_yun'] == 1) {
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
                      } else if (phone['is_yun'] == 0) {
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
                      if (phone['perr_msg'] != 0) f = false;
                    }
                    // tmp.isWrong = tmp.isWrong! || f || !(tmp.wrongShengDiao! || tmp.wrongShengMu! || tmp.wrongYunMu!);
                    oneWordList.add(tmp);
                  }
              } else {
                var syrllJson = wordJson['syll'];
                  if (syrllJson['content'] == 'silv' ||
                      syrllJson['content'] == 'sil' ||
                      syrllJson['content'] == 'fil' || !exp.hasMatch(syrllJson['content'])) {
                    
                  } else {
                  DataOneWordCard tmp = DataOneWordCard();
                  tmp.word = syrllJson['content'];
                  tmp.pinyin = syrllJson['symbol'];
                  tmp.isWrong = syrllJson['dp_message'] != 0;
                  tmp.wrongShengMu = false;
                  tmp.wrongYunMu = false;
                  tmp.wrongShengDiao = false;
                  tmp.shengMu = "";
                  tmp.yunMu = "";
                  tmp.shengDiao = "";
                  if (syrllJson['dp_message'] == 0) {
                  } else if (syrllJson['dp_message'] == 16) {
                    less += 1;
                  } else if (syrllJson['dp_message'] == 32) {
                    more += 1;
                  } else if (syrllJson['dp_message'] == 64) {
                    retro += 1;
                  } else if (syrllJson['dp_message'] == 128) {
                    repl += 1;
                  }
                  bool f = true;
                  final phoneJson = syrllJson['phone'];
                  if (_isJsonList(phoneJson)) {
                    for (var phone in phoneJson) {
                      if (phone['is_yun'] == 1) {
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
                      } else if (phone['is_yun'] == 0) {
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
                      if (phone['perr_msg'] != 0) {
                        tmp.isWrong = true;
                      }
                    }
                  } else {
                    var phone = phoneJson;
                    if (phone['is_yun'] == 1) {
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
                    } else if (phone['is_yun'] == 0) {
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
                    if (phone['perr_msg'] != 0) {
                      if(tmp.isWrong == false) tmp.isWrong = true;
                    }
                  }
                  oneWordList.add(tmp);
                  }
              }
            }
          } else {
            var wordJson = sentanceJson['word'];
            if (_isJsonList(wordJson['syll'])) {
                for (var syrllJson in wordJson['syll']) {
                  if (syrllJson['content'] == 'silv' ||
                      syrllJson['content'] == 'sil' ||
                      syrllJson['content'] == 'fil' || !exp.hasMatch(syrllJson['content'])) {
                    continue;
                  }
                  DataOneWordCard tmp = DataOneWordCard();
                  tmp.word = syrllJson['content'];
                  tmp.pinyin = syrllJson['symbol'];
                  tmp.isWrong = syrllJson['dp_message'] != 0;
                  tmp.wrongShengMu = false;
                  tmp.wrongYunMu = false;
                  tmp.wrongShengDiao = false;
                  tmp.shengMu = "";
                  tmp.yunMu = "";
                  tmp.shengDiao = "";
                  if (syrllJson['dp_message'] == 0) {
                  } else if (syrllJson['dp_message'] == 16) {
                    less += 1;
                  } else if (syrllJson['dp_message'] == 32) {
                    more += 1;
                  } else if (syrllJson['dp_message'] == 64) {
                    retro += 1;
                  } else if (syrllJson['dp_message'] == 128) {
                    repl += 1;
                  }
                  bool f = true;
                  final phoneJson = syrllJson['phone'];
                  if (_isJsonList(phoneJson)) {
                    for (var phone in phoneJson) {
                      if (phone['is_yun'] == 1) {
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
                      } else if (phone['is_yun'] == 0) {
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
                      if (phone['perr_msg'] != 0) {
                        if(tmp.isWrong == false) tmp.isWrong = true;
                      }
                    }
                  } else {
                    var phone = phoneJson;
                    if (phone['is_yun'] == 1) {
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
                    } else if (phone['is_yun'] == 0) {
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
                    if (phone['perr_msg'] != 0) {
                      if(tmp.isWrong == false) tmp.isWrong = true;
                    }
                  }
                  oneWordList.add(tmp);
                }
            } else {
              var syrllJson = wordJson['syll'];
                if (syrllJson['content'] == 'silv' ||
                    syrllJson['content'] == 'sil' ||
                    syrllJson['content'] == 'fil' || !exp.hasMatch(syrllJson['content'])) {
                  continue;
                }
                DataOneWordCard tmp = DataOneWordCard();
                tmp.word = syrllJson['content'];
                tmp.pinyin = syrllJson['symbol'];
                tmp.isWrong =  syrllJson['dp_message'] != 0;
                tmp.wrongShengMu = false;
                tmp.wrongYunMu = false;
                tmp.wrongShengDiao = false;
                tmp.shengMu = "";
                tmp.yunMu = "";
                tmp.shengDiao = "";
                if (syrllJson['dp_message'] == 0) {
                } else if (syrllJson['dp_message'] == 16) {
                  less += 1;
                } else if (syrllJson['dp_message'] == 32) {
                  more += 1;
                } else if (syrllJson['dp_message'] == 64) {
                  retro += 1;
                } else if (syrllJson['dp_message'] == 128) {
                  repl += 1;
                }
                bool f = true;
                final phoneJson = syrllJson['phone'];
                if (_isJsonList(phoneJson)) {
                  for (var phone in phoneJson) {
                    if (phone['is_yun'] == 1) {
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
                    } else if (phone['is_yun'] == 0) {
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
                    if (phone['perr_msg'] != 0) {
                      if(tmp.isWrong == false) tmp.isWrong = true;
                    }
                  }
                } else {
                  var phone = phoneJson;
                  if (phone['is_yun'] == 1) {
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
                  } else if (phone['is_yun'] == 0) {
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
                  if (phone['perr_msg'] != 0) {
                    if(tmp.isWrong == false) tmp.isWrong = true;
                  }
                }
                oneWordList.add(tmp);
            }
          }
        }
    } else {
        var sentanceJson = resultJson['sentence'];
        if (_isJsonList(sentanceJson['word'])) {
          for (var wordJson in sentanceJson['word']) {
            if (_isJsonList(wordJson['syll'])) {
                for (var syrllJson in wordJson['syll']) {
                  if (syrllJson['content'] == 'silv' || syrllJson['content'] == 'sil' || syrllJson['content'] == 'fil' || !exp.hasMatch(syrllJson['content'])) {
                    continue;
                  }
                  DataOneWordCard tmp = DataOneWordCard();
                  tmp.word = syrllJson['content'];
                  tmp.pinyin = syrllJson['symbol'];
                  tmp.isWrong =  syrllJson['dp_message'] != 0;
                  tmp.wrongShengMu = false;
                  tmp.wrongYunMu = false;
                  tmp.wrongShengDiao = false;
                  tmp.shengMu = "";
                  tmp.yunMu = "";
                  tmp.shengDiao = "";
                  if (syrllJson['dp_message'] == 0) {
                  } else if (syrllJson['dp_message'] == 16) {
                    less += 1;
                  } else if (syrllJson['dp_message'] == 32) {
                    more += 1;
                  } else if (syrllJson['dp_message'] == 64) {
                    retro += 1;
                  } else if (syrllJson['dp_message'] == 128) {
                    repl += 1;
                  }
                  bool f = true;
                  final phoneJson = syrllJson['phone'];
                  if (_isJsonList(phoneJson)) {
                    for (var phone in phoneJson) {
                      if (phone['is_yun'] == 1) {
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
                      } else if (phone['is_yun'] == 0) {
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
                      if (phone['perr_msg'] != 0) {
                        if(tmp.isWrong == false) tmp.isWrong = true;
                      }
                    }
                  } else {
                    var phone = phoneJson;
                    if (phone['is_yun'] == 1) {
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
                    } else if (phone['is_yun'] == 0) {
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
                    if (phone['perr_msg'] != 0) {
                      if(tmp.isWrong == false) tmp.isWrong = true;
                    }
                  }
                  oneWordList.add(tmp);
                }
            } else {
              var syrllJson = wordJson['syll'];
                if (syrllJson['content'] == 'silv' ||
                    syrllJson['content'] == 'sil' ||
                    syrllJson['content'] == 'fil' || !exp.hasMatch(syrllJson['content'])) {
                  continue;
                }
                DataOneWordCard tmp = DataOneWordCard();
                tmp.word = syrllJson['content'];
                tmp.pinyin = syrllJson['symbol'];
                tmp.isWrong =  syrllJson['dp_message'] != 0;
                tmp.wrongShengMu = false;
                tmp.wrongYunMu = false;
                tmp.wrongShengDiao = false;
                tmp.shengMu = "";
                tmp.yunMu = "";
                tmp.shengDiao = "";
                if (syrllJson['dp_message'] == 0) {
                } else if (syrllJson['dp_message'] == 16) {
                  less += 1;
                } else if (syrllJson['dp_message'] == 32) {
                  more += 1;
                } else if (syrllJson['dp_message'] == 64) {
                  retro += 1;
                } else if (syrllJson['dp_message'] == 128) {
                  repl += 1;
                }
                bool f = true;
                final phoneJson = syrllJson['phone'];
                if (_isJsonList(phoneJson)) {
                  for (var phone in phoneJson) {
                    if (phone['is_yun'] == 1) {
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
                    } else if (phone['is_yun'] == 0) {
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
                    if (phone['perr_msg'] != 0) {
                      if(tmp.isWrong == false) tmp.isWrong = true;
                    }
                  }
                } else {
                  var phone = phoneJson;
                  if (phone['is_yun'] == 1) {
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
                  } else if (phone['is_yun'] == 0) {
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
                  if (phone['perr_msg'] != 0) {
                    if(tmp.isWrong == false) tmp.isWrong = true;
                  }
                }
                oneWordList.add(tmp);             
            }
          }
        } else {
          var wordJson = sentanceJson['word'];
          if (_isJsonList(wordJson['syll'])) {
              for (var syrllJson in wordJson['syll']) {
                if (syrllJson['content'] == 'silv' ||
                    syrllJson['content'] == 'sil' ||
                    syrllJson['content'] == 'fil' || !exp.hasMatch(syrllJson['content'])) {
                  continue;
                }
                DataOneWordCard tmp = DataOneWordCard();
                tmp.word = syrllJson['content'];
                tmp.pinyin = syrllJson['symbol'];
                tmp.isWrong =  syrllJson['dp_message'] != 0;
                tmp.wrongShengMu = false;
                tmp.wrongYunMu = false;
                tmp.wrongShengDiao = false;
                tmp.shengMu = "";
                tmp.yunMu = "";
                tmp.shengDiao = "";
                if (syrllJson['dp_message'] == 0) {
                } else if (syrllJson['dp_message'] == 16) {
                  less += 1;
                } else if (syrllJson['dp_message'] == 32) {
                  more += 1;
                } else if (syrllJson['dp_message'] == 64) {
                  retro += 1;
                } else if (syrllJson['dp_message'] == 128) {
                  repl += 1;
                }
                bool f = true;
                final phoneJson = syrllJson['phone'];
                if (_isJsonList(phoneJson)) {
                  for (var phone in phoneJson) {
                    if (phone['is_yun'] == 1) {
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
                    } else if (phone['is_yun'] == 0) {
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
                    if (phone['perr_msg'] != 0) {
                      if(tmp.isWrong == false) tmp.isWrong = true;
                    }
                  }
                } else {
                  var phone = phoneJson;
                  if (phone['is_yun'] == 1) {
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
                  } else if (phone['is_yun'] == 0) {
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
                  if (phone['perr_msg'] != 0) {
                    if(tmp.isWrong == false) tmp.isWrong = true;
                  }
                }
                oneWordList.add(tmp);
              }          
          } else {
            var syrllJson = wordJson['syll'];
              if (syrllJson['content'] == 'silv' ||
                  syrllJson['content'] == 'sil' ||
                  syrllJson['content'] == 'fil' || !exp.hasMatch(syrllJson['content'])) {
              } else {
                DataOneWordCard tmp = DataOneWordCard();
                tmp.word = syrllJson['content'];
                tmp.pinyin = syrllJson['symbol'];
                tmp.isWrong = syrllJson['dp_message'] != 0;
                tmp.wrongShengMu = false;
                tmp.wrongYunMu = false;
                tmp.wrongShengDiao = false;
                tmp.shengMu = "";
                tmp.yunMu = "";
                tmp.shengDiao = "";
                if (syrllJson['dp_message'] == 0) {
                } else if (syrllJson['dp_message'] == 16) {
                  less += 1;
                } else if (syrllJson['dp_message'] == 32) {
                  more += 1;
                } else if (syrllJson['dp_message'] == 64) {
                  retro += 1;
                } else if (syrllJson['dp_message'] == 128) {
                  repl += 1;
                }
                bool f = true;
                final phoneJson = syrllJson['phone'];
                if (_isJsonList(phoneJson)) {
                  for (var phone in phoneJson) {
                    if (phone['is_yun'] == 1) {
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
                    } else if (phone['is_yun'] == 0) {
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
                    if (phone['perr_msg'] != 0) {
                      if(tmp.isWrong == false) tmp.isWrong = true;
                    }
                  }
                } else {
                  var phone = phoneJson;
                  if (phone['is_yun'] == 1) {
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
                  } else if (phone['is_yun'] == 0) {
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
                  if (phone['perr_msg'] != 0) {
                    if(tmp.isWrong == false) tmp.isWrong = true;
                  }
                }
                oneWordList.add(tmp);
              }
          }
        }
    }
    
    dataOneResultCard.totalScore = resultJson['total_score'];
    dataOneResultCard.phoneScore = resultJson['phone_score'];
    dataOneResultCard.toneScore = resultJson['tone_score'];
    dataOneResultCard.fluencyScore = resultJson['fluency_score'];
    dataOneResultCard.less = less;
    dataOneResultCard.more = more;
    dataOneResultCard.retro = retro;
    dataOneResultCard.repl = repl;
    dataOneResultCard.dataOneWordCard = oneWordList;
    dataOneResultCard.cpsrcdId = data.id;
    return dataOneResultCard;
  }
}
