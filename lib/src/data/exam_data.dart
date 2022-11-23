import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:mime/mime.dart' as mime;
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:project_soe/src/components/voice_input.dart';

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
  String filePath;
  QuestionPageResultData? resultData;
  QuestionPageData({
    required this.type,
    required this.questionList,
    this.filePath = '',
  });

  Future<void> postAndGetResult() async {
    if (filePath == '') {
      return;
    }
    String mimeLook = mime.lookupMimeType(filePath)!;
    final mimeSplit = mimeLook.split('/');
    var mimeString = mimeSplit[0];
    var mimeType = mimeSplit[1];
    final formData = dio.FormData.fromMap({
      'audio': await dio.MultipartFile.fromFile(
        filePath,
        contentType: http_parser.MediaType(mimeString, mimeType),
      ),
      'text': toSingleString(),
      'mode': questionTypeToInt(type).toString(),
      'pinyin': '',
    });
    final response = await dio.Dio().postUri(
      Uri.parse('http://47.101.58.72:8888/corpus-server/api/test/v1/upload'),
      data: formData,
    );
    resultData = QuestionPageResultData.fromJson(response.data);
  }

  //  22.11.21 此函数弃用, 改用dio
  Future<http.MultipartFile> getMultiPartFileAudio() async {
    dynamic httpAudio;
    if (filePath != '') {
      final bytes = await File(filePath).readAsBytes();
      final fileSplit = filePath.split('\\');
      final String fileName = fileSplit[fileSplit.length - 1];
      httpAudio = http.MultipartFile.fromBytes(fileName, bytes,
          filename: fileName,
          contentType: http_parser.MediaType('audio', 'wav'));
    }
    return httpAudio;
  }

  String toSingleString() {
    if (questionList.isEmpty) {
      throw ('Invalid QuestionList size');
    }
    if (type == QuestionType.poem) {
      List<String> lines = questionList[0].label.split('\\n');
      var ret = '';
      for (String line in lines) {
        ret += line;
        ret += '\n';
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
  const QuestionPageResultData({
    required this.totalWords,
    required this.wrongWords,
    required this.pronCompletion,
    required this.pronAccuracy,
    required this.pronFluency,
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
    };
    return retMap;
  }

  factory QuestionPageResultData.fromJson(Map<String, dynamic> json) {
    return QuestionPageResultData(
      totalWords: (json['total_words_count'] == null)
          ? 0
          : json['total_words_count'] as int,
      wrongWords: (json['wrong_words_count'] == null)
          ? 0
          : json['wrong_words_count'] as int,
      pronAccuracy:
          (json['pronAccuracy'] == null) ? 0 : json['pronAccuracy'] as double,
      pronFluency:
          (json['pronFluency'] == null) ? 0 : json['pronFluency'] as double,
      pronCompletion: (json['pronCompletion'] == null)
          ? 0
          : json['pronCompletion'] as double,
    );
  }
}
