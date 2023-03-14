import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart' as mime;
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:project_soe/src/components/voice_input.dart';
import 'package:project_soe/src/full_exam/full_exam_results.dart';

class FullExamResultScreenArguments {
  final String id;
  final List<VoiceInputPage> inputPages;
  FullExamResultScreenArguments(this.id, this.inputPages);
}

enum QuestionType {
  word,
  sentance,
  article,
  poem,
}

String getXfCategoryString(QuestionType x) {
  switch (x) {
    case QuestionType.word:
      return "read_word";
    case QuestionType.sentance:
      return "read_sentence";
    case QuestionType.article:
      return "read_chapter";
    case QuestionType.poem:
      return "read_chapter";
    default:
      throw ('不支持的格式');
  }
}

String getQuestionTypeInfo(QuestionType x) {
  switch (x) {
    case QuestionType.word:
      return '本题是单词问题';
    case QuestionType.sentance:
      return '本题是句子题';
    case QuestionType.article:
      return '本题是文章题';
    case QuestionType.poem:
      return '本题是读古诗';
    default:
      throw ('不支持的格式');
  }
}

QuestionType questionTypeFromInt(int x) {
  switch (x) {
    case 1:
      return QuestionType.word;
    case 2:
      return QuestionType.sentance;
    case 3:
      return QuestionType.article;
    case 5:
      return QuestionType.poem;
    default:
      throw ("No Such Question Type");
  }
}

int questionTypeToInt(QuestionType t) {
  switch (t) {
    case QuestionType.word:
      return 1;
    case QuestionType.sentance:
      return 2;
    case QuestionType.article:
      return 3;
    case QuestionType.poem:
      return 5;
    default:
      throw ("No Such Question Type");
  }
}

class QuestionPageData {
  final QuestionType type;
  final List<QuestionData> questionList;
  bool isRecording = false;
  bool _isUploading = false;
  String filePath;
  QuestionPageResultData? resultData;
  QuestionPageResultDataXf? resultDataXf;
  QuestionPageData({
    required this.type,
    required this.questionList,
    this.filePath = '',
  });

  bool hasRecord() {
    return filePath != '';
  }

  void setUploading(bool b) {
    _isUploading = b;
  }

  bool isUploading() {
    return _isUploading;
  }

  Future<void> postAndGetResultXf() async {
    if (filePath == '') {
      return;
    }
    _isUploading = true;
    final uri = Uri.parse(
        'http://47.101.58.72:8888/corpus-server/api/evaluate/v1/eval_xf');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await getMultiPartFileAudio());
    request.fields['refText'] = toSingleString();
    request.fields['category'] = getXfCategoryString(type);
    request.headers['Content-Type'] = 'multipart/form-data';
    final response = await request.send();
    final responseBytes = await response.stream.toBytes();
    // final responseString = String.fromCharCodes(responseBytes);
    // final decoded = jsonDecode(responseString);
    final u8decoded = utf8.decode(responseBytes);
    final decoded = jsonDecode(u8decoded);
    resultDataXf = QuestionPageResultDataXf(type: this.type);
    resultDataXf!.parseJson(decoded['data']);
    _isUploading = false;
  }

  Future<void> postAndGetResult() async {
    // FIXME 23.3.2 暂时使用科大讯飞的接口.
    await postAndGetResultXf();
    return;
    /*
    if (filePath == '') {
      return;
    }
    _isUploading = true;
    final uri = Uri.parse(
        'http://47.101.58.72:8888/corpus-server/api/evaluate/v1/eval');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await getMultiPartFileAudio());
    request.fields['refText'] = toSingleString();
    request.fields['evalMode'] = '2';
    request.fields['pinyin'] = '';
    request.headers['Content-Type'] = 'multipart/form-data';
    final response = await request.send();
    final responseBytes = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseBytes);
    final decoded = jsonDecode(responseString);
    resultData = QuestionPageResultData.fromJson(decoded['data']);
    _isUploading = false;
    */
  }

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

  String toSingleString() {
    if (questionList.isEmpty) {
      throw ('Invalid QuestionList size');
    }
    // 古诗, 处理分段
    if (type == QuestionType.poem) {
      List<String> lines = questionList[0].label.split('\\n');
      var ret = '';
      for (String line in lines) {
        ret += line;
        ret += '\n';
      }
      return ret;
    }
    // 文章, 分段加空格.
    if (type == QuestionType.article) {
      List<String> lines = questionList[0].label.split('\\n');
      var ret = '    ';
      for (String line in lines) {
        ret += line;
        ret += '\n    ';
      }
      return ret;
    }
    if (questionList.length == 1) {
      return questionList[0].label;
    }
    String single = questionList[0].label;
    single += '\n';
    for (int i = 1; i < questionList.length; ++i) {
      single += questionList[i].label;
      single += '\n';
    }
    return single;
  }

  // 22.11.19 此函数弃用, 只适用于之前的接口.
  Future<Map<String, dynamic>> toDynamicMap() async {
    List<Map<String, dynamic>> wordList = [];
    for (QuestionData questionData in questionList) {
      wordList.add(questionData.toDynamicMap());
    }

    Map<String, dynamic> json = {
      'type': questionTypeToInt(type).toString(),
      'audioName': filePath == ''
          ? ''
          : filePath.split('\\')[filePath.split('\\').length - 1],
      'refText': wordList,
    };
    return json;
  }
}

class QuestionData {
  final String id;
  final int order;
  final String label;
  const QuestionData({
    required this.id,
    required this.order,
    required this.label,
  });
  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      id: json['id'] as String,
      order: json['order'] as int,
      label: json['refText'] as String,
    );
  }
  Map<String, dynamic> toDynamicMap() {
    Map<String, dynamic> json = {};
    json['word'] = label;
    json['pinyin'] = '';
    return json;
  }
}

class QuestionPageResultData {
  final int totalWords;
  final int wrongWords;
  final double proportion = 0.2;
  final double pronCompletion;
  final double pronAccuracy;
  final double pronFluency;
  final double suggestedScore;
  const QuestionPageResultData({
    required this.totalWords,
    required this.wrongWords,
    required this.pronCompletion,
    required this.pronAccuracy,
    required this.pronFluency,
    required this.suggestedScore,
  });

  Map<String, dynamic> getJsonMap(int id) {
    final retMap = {
      'subTopic': id,
      // FIXME 22.11.19 这些数据目前保留
      'proportion': 0.0,
      'totalWords': totalWords,
      'wrongWords': wrongWords,
      'pronCompletion': pronCompletion,
      'pronAccuracy': pronAccuracy,
      'pronFluency': pronFluency,
      'suggestedScore': suggestedScore,
    };
    return retMap;
  }

  factory QuestionPageResultData.fromJson(Map<String, dynamic> json) {
    return QuestionPageResultData(
      totalWords: (json['totalWordCount'] == null)
          ? 0
          : json['totalWordCount'] as int > 0
              ? json['totalWordCount'] as int
              : 0,
      wrongWords: (json['wrongWordsCount'] == null)
          ? 0
          : json['wrongWordsCount'] as int > 0
              ? json['wrongWordsCount'] as int
              : 0,
      pronAccuracy: (json['pronAccuracy'] == null)
          ? 0.0
          : json['pronAccuracy'] as double >= 0.0
              ? json['pronAccuracy'] as double
              : 0.0,
      pronFluency: (json['pronFluency'] == null)
          ? 0.0
          : json['pronFluency'] as double >= 0.0
              ? json['pronFluency'] as double
              : 0.0,
      pronCompletion: (json['pronCompletion'] == null)
          ? 0.0
          : json['pronCompletion'] as double >= 0.0
              ? json['pronCompletion'] as double
              : 0.0,
      suggestedScore: (json['suggestedScore'] == null)
          ? 0.0
          : json['suggestedScore'] as double >= 0.0
              ? json['suggestedScore'] as double
              : 0.0,
    );
  }
}

// phone_score 	声韵分
// fluency_score 	流畅度分（暂会返回0分）
// tone_score 	调型分
// total_score 	总分
// beg_pos/end_pos 	始末位置（单位：帧，每帧相当于10ms)
// content 	试卷内容
// time_len 	时长（单位：帧，每帧相当于10ms）
class QuestionPageResultDataXf {
  bool jsonParsed;
  QuestionType type;
  double fluencyScore;
  double phoneScore;
  double toneScore;
  double totalScore;
  int more; // 增读
  int less; // 漏读
  int retro; // 回读
  int repl; // 替换
  late List<MonoTone> wrongMonotones;
  late List<WrongPhone> wrongSheng;
  late List<WrongPhone> wrongYun;
  QuestionPageResultDataXf({
    required this.type,
    this.jsonParsed = false,
    this.fluencyScore = 0.0,
    this.phoneScore = 0.0,
    this.toneScore = 0.0,
    this.totalScore = 0.0,
    this.more = 0,
    this.less = 0,
    this.retro = 0,
    this.repl = 0,
  }) {
    wrongMonotones = List.empty(growable: true);
    wrongSheng = List.empty(growable: true);
    wrongYun = List.empty(growable: true);
  }
  void parsePhone(Map<String, dynamic> phone, Map<String, dynamic> syrllJson) {
    if (phone['perr_msg'] != 0) {
      if (phone['is_yun'] == 1) {
        if (phone['perr_msg'] == 1) {
          wrongYun.add(
            WrongPhone(
              word: syrllJson['content'],
              yunmu: phone['content'],
              shengmu: '',
              isShengWrong: false,
            ),
          );
        } else if (phone['perr_msg'] == 2) {
          wrongMonotones.add(
            MonoTone(
                word: syrllJson['content'],
                tone: getMonoToneIntFromString(phone['mono_tone'])),
          );
        } else if (phone['perr_msg'] == 3) {
          wrongYun.add(
            WrongPhone(
              word: syrllJson['content'],
              yunmu: phone['content'],
              shengmu: '',
              isShengWrong: false,
            ),
          );
          wrongMonotones.add(
            MonoTone(
                word: syrllJson['content'],
                tone: getMonoToneIntFromString(phone['mono_tone'])),
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

  void parseSyrll(Map<String, dynamic> syrllJson) {
    if (syrllJson['content'] == 'silv' || syrllJson['content'] == 'sil') {
      return;
    }
    try {
      if (syrllJson['dp_message'] == 0) {
        // int rightMonotone =
        //     getMonoToneIntFromPinyin(syrllJson['symbol'].toString());
        final phoneJson = syrllJson['phone'];
        if (_isJsonList(phoneJson)) {
          for (var phone in phoneJson) {
            parsePhone(phone, syrllJson);
          }
        } else {
          parsePhone(phoneJson, syrllJson);
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

  void parseWord(Map<String, dynamic> wordJson) {
    if (_isJsonList(wordJson['syll'])) {
      for (var syrllJson in wordJson['syll']) {
        parseSyrll(syrllJson);
      }
    } else {
      parseSyrll(wordJson['syll']);
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
    String category = getXfCategoryString(type);
    Map<String, dynamic> resultJson = json['rec_paper'][category];
    fluencyScore = resultJson['fluency_score'];
    phoneScore = resultJson['phone_score'];
    totalScore = resultJson['total_score'];
    toneScore = resultJson['tone_score'];
    for (var sentanceJson in resultJson['sentence']) {
      if (_isJsonList(sentanceJson['word'])) {
        for (var wordJson in sentanceJson['word']) {
          parseWord(wordJson);
        }
      } else {
        parseWord(sentanceJson['word']);
      }
    }
    jsonParsed = true;
  }
}

class WrongPhone {
  final String word;
  final String shengmu;
  final String yunmu;
  final bool isShengWrong;
  const WrongPhone({
    required this.word,
    required this.shengmu,
    required this.yunmu,
    required this.isShengWrong,
  });
}

int getMonoToneIntFromPinyin(String pinyin) {
  if (pinyin == null) {
    return 0;
  }
  int rightMonotone = 0;
  int pinyinLength = pinyin.length;
  rightMonotone = int.parse(pinyin[pinyinLength - 1]);
  return rightMonotone;
}

int getMonoToneIntFromString(String monoTone) {
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
      return -1;
  }
}

class MonoTone {
  final Char word;
  final int tone;
  const MonoTone({required this.word, required this.tone});
}

class FullExaminationResultDataXf {}
