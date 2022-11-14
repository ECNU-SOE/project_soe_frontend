import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:http/http.dart' as http;

class FullExamData {
  final List<String> singleWords;
  final List<String> doubleWords;
  final List<String> sentances;
  const FullExamData(
    this.singleWords,
    this.doubleWords,
    this.sentances,
  );
}

enum QuestionType {
  word,
  sentance,
  article,
  poem,
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
  QuestionPageData({
    required this.type,
    required this.questionList,
    this.filePath = '',
  });

  Future<http.MultipartFile> getMultiPartFileAudio() async {
    dynamic httpAudio;
    if (filePath != '') {
      final bytes = await File(filePath).readAsBytes();
      final fileSplit = filePath.split('\\');
      final String fileName = fileSplit[fileSplit.length - 1];
      httpAudio =
          http.MultipartFile.fromBytes(fileName, bytes, filename: fileName);
    }
    return httpAudio;
  }

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
