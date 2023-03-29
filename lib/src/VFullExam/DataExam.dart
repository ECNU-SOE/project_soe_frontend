import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart' as mime;
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

import 'package:project_soe/src/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/src/CComponents/LogicPingyinlizer.dart'
    as pinyinlizer;
import 'package:project_soe/src/VFullExam/ViewFullExamResults.dart';

class FullExamResultScreenArguments {
  final String id;
  final List<QuestionPageData> pageDatas;
  FullExamResultScreenArguments(this.id, this.pageDatas);
}

enum QuestionType {
  word,
  sentance,
  article,
  poem,
}

// 转换为拼音 pin1 yin1 -> pīn yīn
String getStringFromPinyin(String pinyin) {
  return pinyinlizer.Pinyinizer().pinyinize(pinyin);
}

// 获取调型对应的文本
String getLabelFromMonotoneInt(int monoTone) {
  switch (monoTone) {
    case 1:
      return '一声';
    case 2:
      return '二声';
    case 3:
      return '三声';
    case 4:
      return '四声';
    default:
      throw ('没有该调型');
  }
}

// 获取讯飞数据的解析格式
String getXfCategoryStringByInt(int x) {
  switch (x) {
    case 2:
      return 'read_word';
    case 3:
      return 'read_sentence';
    case 4:
      return 'read_chapter';
    default:
      throw ('不支持的格式');
  }
}

// 错误声韵母列表整理为一个String
String getStringLabelFromWrongPhoneList(List<WrongPhone> phoneList) {
  String ret = '';
  for (WrongPhone phone in phoneList) {
    ret += phone.word;
    ret += phone.pinyinString;
  }
  return ret;
}

// 错误调型列表整理为一个String
String getStringLabelFromWrongMonoList(List<WrongMonoTone> monoList) {
  String ret = '';
  for (WrongMonoTone monoTone in monoList) {
    ret += monoTone.word;
    ret += monoTone.pinyinString;
  }
  return ret;
}

// 获取调型Int 1234
int getMonoToneIntFromPinyin(String pinyin) {
  if (pinyin == null) {
    return 0;
  }
  int rightMonotone = 0;
  int pinyinLength = pinyin.length;
  rightMonotone = int.parse(pinyin[pinyinLength - 1]);
  return rightMonotone;
}

// 获取调型String
int getMonoToneIntFromMsgString(String monoTone) {
  switch (monoTone) {
    case 'TONE1':
      return 1;
    case 'TONE2':
      return 2;
    case 'TONE3':
      return 3;
    case 'TONE4':
      return 4;
    default:
      throw ('没有该调型');
  }
}

class ParsedResultsXf {
  List<QuestionPageResultDataXf> resultList;
  double weightedScore;
  double totalWeight;
  Map<String, List<WrongPhone>> wrongShengs;
  Map<String, List<WrongPhone>> wrongYuns;
  Map<String, List<WrongMonoTone>> wrongMonos;

  ParsedResultsXf({
    required this.resultList,
    required this.weightedScore,
    required this.totalWeight,
    required this.wrongShengs,
    required this.wrongYuns,
    required this.wrongMonos,
  });

  String toJson() {
    String ret = '';
    ret += '{';
    ret += 'wrongSheng:{';
    for (final wrongSheng in wrongShengs.keys) {
      ret += wrongSheng + ':[';
      final lst = wrongShengs[wrongSheng];
      if (lst != null) {
        for (final ws in lst) {
          ret += '{${ws.toJson()}},';
        }
      }
      ret += '],';
    }
    ret += '},';
    ret += 'wrongYun:{';

    for (final wys in wrongYuns.keys) {
      ret += wys + ':[';
      final lst = wrongShengs[wys];
      if (lst != null) {
        for (final wy in lst) {
          ret += '${wy.toJson()},';
        }
      }
      ret += '],';
    }
    ret += '},';
    ret += 'wrongMono:{';

    for (final wms in wrongMonos.keys) {
      ret += wms + ':[';
      final lst = wrongShengs[wms];
      if (lst != null) {
        for (final wm in lst) {
          ret += '{${wm.toJson()}},';
        }
      }
      ret += '],';
    }
    ret += '},';
    ret += '}';
    return ret;
  }

  factory ParsedResultsXf.fromQuestionPageDataList(
      List<QuestionPageData> pageDatas) {
    List<QuestionPageResultDataXf> list = List.empty(growable: true);
    double weightedScore = 0.0;
    double totalWeight = 0.0;
    for (var pageData in pageDatas) {
      double pageWeight = pageData.weight;
      totalWeight += pageWeight;
      if (pageData.resultDataXf != null) {
        list.add(pageData.resultDataXf!);
        weightedScore += pageData.resultDataXf!.totalScore * pageWeight;
      }
    }
    Map<String, List<WrongPhone>> wrongShengs = Map.identity();
    Map<String, List<WrongPhone>> wrongYuns = Map.identity();
    Map<String, List<WrongMonoTone>> wrongMonos = Map.identity();
    for (var resultXf in list) {
      if (resultXf.wrongSheng.isNotEmpty) {
        for (var sheng in resultXf.wrongSheng) {
          if (!wrongShengs.containsKey(sheng.shengmu)) {
            wrongShengs[sheng.shengmu] = List.empty(growable: true);
          }
          wrongShengs[sheng.shengmu]!.add(sheng);
        }
      }
      if (resultXf.wrongYun.isNotEmpty) {
        for (var yun in resultXf.wrongYun) {
          if (!wrongYuns.containsKey(yun.yunmu)) {
            wrongYuns[yun.yunmu] = List.empty(growable: true);
          }
          wrongYuns[yun.yunmu]!.add(yun);
        }
      }
      if (resultXf.wrongMonotones.isNotEmpty) {
        for (var mono in resultXf.wrongMonotones) {
          String toneLabel = getLabelFromMonotoneInt(mono.tone);
          if (!wrongMonos.containsKey(toneLabel)) {
            wrongMonos[toneLabel] = List.empty(growable: true);
          }
          wrongMonos[toneLabel]!.add(mono);
        }
      }
    }
    return ParsedResultsXf(
      weightedScore: (weightedScore / totalWeight),
      totalWeight: totalWeight,
      resultList: list,
      wrongShengs: wrongShengs,
      wrongYuns: wrongYuns,
      wrongMonos: wrongMonos,
    );
  }
}

// 每一页题目的数据.
class QuestionPageData {
  // final QuestionType type;
  final double weight;
  final String cpsgrpId;
  final String id;
  final String desc;
  final String title;
  final int evalMode;
  final List<QuestionData> questionList;
  bool isRecording = false;
  bool isUploading = false;
  String filePath;
  // 评测以页为单位, 因此页数据内包含结果
  QuestionPageResultDataXf? resultDataXf;
  QuestionPageData({
    // required this.type,
    required this.questionList,
    required this.cpsgrpId,
    required this.id,
    required this.weight,
    required this.desc,
    required this.title,
    required this.evalMode,
    this.filePath = '',
  });

  // 发送结果至服务器评测
  Future<void> postAndGetResultXf() async {
    if (filePath == '') {
      return;
    }
    isUploading = true;
    // 指定URI
    final uri = Uri.parse(
        'http://47.101.58.72:8888/corpus-server/api/evaluate/v1/eval_xf');
    // 指定Request类型
    var request = http.MultipartRequest('POST', uri);
    // 添加文件
    request.files.add(await getMultiPartFileAudio());
    // 添加Fields
    request.fields['refText'] = toSingleString();
    request.fields['category'] = getXfCategoryStringByInt(evalMode);
    // 设置Headers
    request.headers['Content-Type'] = 'multipart/form-data';
    // 发送 并等待返回
    final response = await request.send();
    // 将返回转换为字节流, 并解码
    final decoded = jsonDecode(utf8.decode(await response.stream.toBytes()));
    // 处理解码后的数据
    resultDataXf = QuestionPageResultDataXf(evalMode: evalMode, weight: weight);
    resultDataXf!.parseJson(decoded['data']);
    // 标定状态
    isUploading = false;
  }

  // 将语音文件转换为可以被发送的 MultiPartFileAudio
  Future<http.MultipartFile> getMultiPartFileAudio() async {
    dynamic httpAudio;
    if (filePath != '') {
      final bytes = await File(filePath).readAsBytes();
      final fileSplit = filePath.split('\\');
      final String fileName = fileSplit[fileSplit.length - 1];
      final String mimeLook = mime.lookupMimeType(filePath)!;
      final mimeSplit = mimeLook.split('/');
      final String mimeString = mimeSplit[0];
      final String mimeType = mimeSplit[1];
      httpAudio = http.MultipartFile.fromBytes(
        'audio',
        bytes,
        filename: fileName,
        contentType: http_parser.MediaType(
          mimeString,
          mimeType,
        ),
      );
    }
    return httpAudio;
  }

  // 把所有题目内容变成一个String, 方便界面显示.
  String toSingleString({bool withScore = false}) {
    if (questionList.isEmpty) {
      throw ('Invalid QuestionList size');
    }
    String ret = '';
    for (final question in questionList) {
      List<String> lines = question.label.split('\\n');
      for (String line in lines) {
        ret += (evalMode == 4 ? '     ' : '') + line;
        ret += '\n';
      }
    }
    return ret;
  }
}

// 每一道题的数据
class QuestionData {
  final String id;
  final String label;
  final int evalMode;
  final String cpsgrpId;
  final String topicId;
  const QuestionData({
    required this.id,
    required this.label,
    required this.cpsgrpId,
    required this.topicId,
    required this.evalMode,
  });
  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      id: json['id'] as String,
      label: json['refText'] as String,
      cpsgrpId: json['cpsgrpId'] as String,
      topicId: json['topicId'] as String,
      evalMode: json['evalMode'] as int,
    );
  }
  Map<String, dynamic> toDynamicMap() {
    Map<String, dynamic> json = {};
    json['word'] = label;
    json['pinyin'] = '';
    return json;
  }
}

// 科大讯飞评测得到的结果
// phone_score 	声韵分
// fluency_score 	流畅度分（暂会返回0分）
// tone_score 	调型分
// total_score 	总分
// beg_pos/end_pos 	始末位置（单位：帧，每帧相当于10ms)
// content 	试卷内容
// time_len 	时长（单位：帧，每帧相当于10ms）
class QuestionPageResultDataXf {
  double weight;
  double weightedScore;
  bool jsonParsed;
  int evalMode;
  double fluencyScore;
  double phoneScore;
  double toneScore;
  double totalScore;
  int more; // 增读
  int less; // 漏读
  int retro; // 回读
  int repl; // 替换
  late List<WrongMonoTone> wrongMonotones;
  late List<WrongPhone> wrongSheng;
  late List<WrongPhone> wrongYun;
  QuestionPageResultDataXf({
    required this.evalMode,
    required this.weight,
    this.jsonParsed = false,
    this.fluencyScore = 0.0,
    this.phoneScore = 0.0,
    this.toneScore = 0.0,
    this.totalScore = 0.0,
    this.more = 0,
    this.less = 0,
    this.retro = 0,
    this.repl = 0,
    this.weightedScore = 0.0,
  }) {
    weightedScore = weight * totalScore;
    wrongMonotones = List.empty(growable: true);
    wrongSheng = List.empty(growable: true);
    wrongYun = List.empty(growable: true);
  }
  void _parsePhone(Map<String, dynamic> phone, Map<String, dynamic> syrllJson) {
    if (phone['perr_msg'] != 0) {
      if (phone['is_yun'] == 1) {
        if (phone['perr_msg'] == 1) {
          wrongYun.add(
            WrongPhone(
              word: syrllJson['content'],
              yunmu: phone['content'],
              shengmu: '',
              isShengWrong: false,
              pinyinString: getStringFromPinyin(syrllJson['symbol']),
            ),
          );
        } else if (phone['perr_msg'] == 2) {
          wrongMonotones.add(
            WrongMonoTone(
              word: syrllJson['content'],
              tone: getMonoToneIntFromMsgString(phone['mono_tone']),
              pinyinString: getStringFromPinyin(syrllJson['symbol']),
            ),
          );
        } else if (phone['perr_msg'] == 3) {
          wrongYun.add(
            WrongPhone(
                word: syrllJson['content'],
                yunmu: phone['content'],
                shengmu: '',
                isShengWrong: false,
                pinyinString: getStringFromPinyin(syrllJson['symbol'])),
          );
          wrongMonotones.add(
            WrongMonoTone(
              word: syrllJson['content'],
              tone: getMonoToneIntFromMsgString(phone['mono_tone']),
              pinyinString: getStringFromPinyin(syrllJson['symbol']),
            ),
          );
        } else {
          throw ('未知的错误信息');
        }
      } else if (phone['is_yun'] == 0) {
        if (phone['perr_msg'] == 1) {
          wrongSheng.add(
            WrongPhone(
              word: syrllJson['content'],
              yunmu: '',
              shengmu: phone['content'],
              isShengWrong: true,
              pinyinString: getStringFromPinyin(syrllJson['symbol']),
            ),
          );
        } else {
          throw ('未知的错误信息');
        }
      } else {
        throw ('错误的声韵母信息');
      }
    }
  }

  void _parseSyrll(Map<String, dynamic> syrllJson) {
    if (syrllJson['content'] == 'silv' ||
        syrllJson['content'] == 'sil' ||
        syrllJson['content'] == 'fil') {
      return;
    }
    try {
      if (syrllJson['dp_message'] == 0) {
        // int rightMonotone =
        //     getMonoToneIntFromPinyin(syrllJson['symbol'].toString());
        final phoneJson = syrllJson['phone'];
        if (_isJsonList(phoneJson)) {
          for (var phone in phoneJson) {
            _parsePhone(phone, syrllJson);
          }
        } else {
          _parsePhone(phoneJson, syrllJson);
        }
      } else {
        switch (syrllJson['dp_message']) {
          case 16:
            less++;
            break;
          case 32:
            more++;
            break;
          case 64:
            retro++;
            break;
          case 128:
            repl++;
            break;
          default:
            break;
        }
      }
    } catch (_) {}
  }

  void _parseWord(Map<String, dynamic> wordJson) {
    if (_isJsonList(wordJson['syll'])) {
      for (var syrllJson in wordJson['syll']) {
        _parseSyrll(syrllJson);
      }
    } else {
      _parseSyrll(wordJson['syll']);
    }
  }

  bool _isJsonList(var json) {
    final ret = json[1];
    if (ret != null) {
      return true;
    } else {
      return false;
    }
  }

  void parseJson(Map<String, dynamic> json) {
    String category = getXfCategoryStringByInt(evalMode);
    Map<String, dynamic> resultJson = json['rec_paper'][category];
    fluencyScore = resultJson['fluency_score'];
    phoneScore = resultJson['phone_score'];
    totalScore = resultJson['total_score'];
    toneScore = resultJson['tone_score'];
    for (var sentanceJson in resultJson['sentence']) {
      if (_isJsonList(sentanceJson['word'])) {
        for (var wordJson in sentanceJson['word']) {
          _parseWord(wordJson);
        }
      } else {
        _parseWord(sentanceJson['word']);
      }
    }
    jsonParsed = true;
  }
}

// 错误的声韵母
class WrongPhone {
  final String word;
  final String shengmu;
  final String yunmu;
  final bool isShengWrong;
  final String pinyinString;
  const WrongPhone({
    required this.word,
    required this.shengmu,
    required this.yunmu,
    required this.isShengWrong,
    required this.pinyinString,
  });

  String toJson() {
    final map = {
      'word': word,
      'shengmu': shengmu,
      'yunmu': yunmu,
      'isShengWrong': isShengWrong,
      'pinyinString': pinyinString,
    };
    return jsonEncode(map);
  }
}

// 错误的调型
class WrongMonoTone {
  final String word;
  final int tone;
  final String pinyinString;
  const WrongMonoTone({
    required this.word,
    required this.tone,
    required this.pinyinString,
  });

  String toJson() {
    final map = {
      'word': word,
      'tone': tone,
      'pinyin': pinyinString,
    };
    return jsonEncode(map);
  }
}
