import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart' as mime;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:lpinyin/lpinyin.dart';

import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/CComponents/LogicPingyinlizer.dart' as pinyinlizer;
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VCommon/DataAllResultsCard.dart';
import 'package:project_soe/VExam/MsgQuestion.dart';
import 'package:project_soe/VExam/ViewExamResults.dart';
import 'package:project_soe/LNavigation/LogicNavigation.dart';
import 'package:quiver/strings.dart';

class ArgsViewExamResult {
  final String id;
  final String endingRoute;
  final List<DataOneResultCard> dataList;
  double sumScore = 0;
  ArgsViewExamResult(this.id, this.dataList, this.endingRoute, this.sumScore);
}

class ArgsViewExam {
  final String cprsgrpId;
  final String title;
  final String endingRoute;
  double sumScore = 0;
  ArgsViewExam(this.cprsgrpId, this.title, this.endingRoute, this.sumScore) {
    if (sNavigationRoutes[endingRoute] == null) {
      throw ('ROUTE NAME NOT FOUND');
    }
  }
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
      return 'read_syllable';
  }
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

class DataExamPage {
  String? id;
  String? classId;
  String? title;
  String? description;
  String? type;
  String? difficulty;
  String? releaseStatus;
  int? isPrivate;
  int? modStatus;
  List<Tags>? tags;
  String? startTime;
  String? endTime;
  String? creator;
  String? gmtCreate;
  String? gmtModified;
  List<Topics>? topics;

  DataExamPage(
      {this.id,
      this.classId,
      this.title,
      this.description,
      this.type,
      this.difficulty,
      this.releaseStatus,
      this.isPrivate,
      this.modStatus,
      this.tags,
      this.startTime,
      this.endTime,
      this.creator,
      this.gmtCreate,
      this.gmtModified,
      this.topics});

  DataExamPage.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    classId = json['classId'] ?? "";
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    type = json['type'] ?? "";
    difficulty = json['difficulty'] ?? "";
    releaseStatus = json['releaseStatus'] ?? "";
    isPrivate = json['isPrivate'] ?? -1;
    modStatus = json['modStatus'] ?? -1;
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
    startTime = json['startTime'] ?? "";
    endTime = json['endTime'] ?? "";
    creator = json['creator'] ?? "";
    gmtCreate = json['gmtCreate'] ?? "";
    gmtModified = json['gmtModified'] ?? "";
    if (json['topics'] != null) {
      topics = <Topics>[];
      json['topics'].forEach((v) {
        topics!.add(new Topics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['classId'] = this.classId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['type'] = this.type;
    data['difficulty'] = this.difficulty;
    data['releaseStatus'] = this.releaseStatus;
    data['isPrivate'] = this.isPrivate;
    data['modStatus'] = this.modStatus;
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['creator'] = this.creator;
    data['gmtCreate'] = this.gmtCreate;
    data['gmtModified'] = this.gmtModified;
    if (this.topics != null) {
      data['topics'] = this.topics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topics {
  String? id;
  String? cpsgrpId;
  String? title;
  double? score;
  int? difficulty;
  String? description;
  List<SubCpsrcds>? subCpsrcds;
  int? tNum;

  Topics(
      {this.id,
      this.cpsgrpId,
      this.title,
      this.score,
      this.difficulty,
      this.description,
      this.subCpsrcds,
      this.tNum});

  Topics.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    cpsgrpId = json['cpsgrpId'] ?? "";
    title = json['title'] ?? "";
    score = json['score'] ?? -1;
    difficulty = json['difficulty'] ?? -1;
    description = json['description'] ?? "";
    tNum = json['tNum'] ?? -1;
    if (json['subCpsrcds'] != null) {
      subCpsrcds = <SubCpsrcds>[];
      json['subCpsrcds'].forEach((v) {
        subCpsrcds!.add(new SubCpsrcds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cpsgrpId'] = this.cpsgrpId;
    data['title'] = this.title;
    data['score'] = this.score;
    data['difficulty'] = this.difficulty;
    data['description'] = this.description;
    if (this.subCpsrcds != null) {
      data['subCpsrcds'] = this.subCpsrcds!.map((v) => v.toJson()).toList();
    }
    data['tNum'] = this.tNum;
    return data;
  }
}

class SubCpsrcds {
  String? id;
  String? topicId;
  String? cpsgrpId;
  String? type;
  String? title;
  int? evalMode;
  int? difficulty;
  double? score;
  bool? enablePinyin = false;
  String? pinyin;
  String? refText;
  String? audioUrl;
  String? description;
  List<Tags>? tags;
  String? gmtCreate;
  String? gmtModified;

  int? tNum;
  int? cNum;
  bool _isRecording = false;
  bool _isUploading = false;
  String _filePath = '';
  bool _isPlayingExample = false;
  bool _isStartPlaying = false;
  double playingProgress = 0.0;

  String _audioUrl = "";
  bool _isPlayingWord = false;
  bool _isStartPlayingWord = false;
  double playingProgressWord = 0.0;

  DataOneResultCard? dataOneResultCard;

  AudioPlayer audioPlayer = AudioPlayer();

  SubCpsrcds(
      {this.id,
      this.topicId,
      this.cpsgrpId,
      this.type,
      this.evalMode,
      this.difficulty,
      this.score,
      this.enablePinyin,
      this.pinyin,
      this.refText,
      this.audioUrl,
      this.description,
      this.tags,
      this.gmtCreate,
      this.gmtModified,
      this.tNum,
      this.cNum});

  SubCpsrcds.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    topicId = json['topicId'] ?? "";
    cpsgrpId = json['cpsgrpId'] ?? "";
    type = json['type'] ?? "";
    evalMode = json['evalMode'] ?? -1;
    difficulty = json['difficulty'] ?? -1;
    score = json['score'] ?? 0.0;
    enablePinyin = json['enablePinyin'] ?? false;
    pinyin = json['pinyin'] ?? "";
    refText = json['refText'] ?? "";
    audioUrl = json['audioUrl'] ?? "";
    description = json['description'] ?? "";
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
    gmtCreate = json['gmtCreate'] ?? "";
    gmtModified = json['gmtModified'] ?? "";
    tNum = json['tNum'] ?? -1;
    cNum = json['cNum'] ?? -1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topicId'] = this.topicId;
    data['cpsgrpId'] = this.cpsgrpId;
    data['type'] = this.type;
    data['evalMode'] = this.evalMode;
    data['difficulty'] = this.difficulty;
    data['score'] = this.score;
    data['enablePinyin'] = this.enablePinyin;
    data['pinyin'] = this.pinyin;
    data['refText'] = this.refText;
    data['audioUrl'] = this.audioUrl;
    data['description'] = this.description;
    data['tags'] = this.tags;
    data['gmtCreate'] = this.gmtCreate;
    data['gmtModified'] = this.gmtModified;
    data['cNum'] = this.cNum;
    data['tNum'] = this.tNum;
    return data;
  }

  // 录音 -------
  bool hasRecordFile() {
    return _filePath != '';
  }

  void setFilePath(String filePath) {
    _filePath = filePath;
  }

  String getFilePath() {
    return _filePath;
  }

  bool isRecording() {
    return _isRecording;
  }

  void setRecording(bool bRecording) {
    _isRecording = bRecording;
  }

  bool isUploading() {
    return _isUploading;
  }

  void setUploading(bool bUploading) {
    _isUploading = bUploading;
  }

  Future<http.MultipartFile> getMultiPartFileAudio() async {
    print("录音地址：" + _filePath);
    dynamic httpAudio;
    if (_filePath != '') {
      final bytes = await File(_filePath).readAsBytes();
      final fileSplit = _filePath.split('\\');
      final String fileName = fileSplit[fileSplit.length - 1];
      final String mimeLook = mime.lookupMimeType(_filePath)!;
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

  // 播放
  bool isStartPlaying() {
    return _isStartPlaying;
  }

  void setStartPlaying(bool bStart) {
    _isStartPlaying = bStart;
  }

  bool isPlayingExample() {
    return _isPlayingExample;
  }

  void setPlayingExample(bool bPlayingExample) {
    _isPlayingExample = bPlayingExample;
  }

  // 播放word
  bool isStartPlayingWord() {
    return _isStartPlayingWord;
  }

  void setStartPlayingWord(bool bStart) {
    _isStartPlayingWord = bStart;
  }

  bool isPlayingWord() {
    return _isPlayingWord;
  }

  void setPlayingWord(bool bPlayingWord) {
    _isPlayingWord = bPlayingWord;
  }

  // -------

  String toSingleString() {
    return '';
  }

  // 虚函数, 用来获取评测时的满分
  double getWeight() {
    return 100.0;
  }

  // 创造题目内容中每一个字
  Column getOneWord(
      String c, String py, double adaptSize, bool f, bool enablePinyin) {
    RegExp exp = RegExp(r"[\u4e00-\u9fa5]");
    String _py = py;
    if (py.length != 0 && py[py.length - 1] == '0') {
      py = py.substring(0, py.length - 1);
    } else {
      py = pinyinlizer.Pinyinizer().pinyinize(py);
    }
    double WIDTH = c != " " && c != "\t" ? 16 : 15;
    return Column(
      children: [
        Container(
            width: WIDTH,
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: enablePinyin ? py : "",
                  style: TextStyle(
                    fontFamily: '楷体',
                    color: f ? Color(0xefff1e1e) : Color(0xff2a2a2a),
                    fontSize: py.length <= 4 ? adaptSize - 5 : adaptSize - 6,
                  ),
                ),
              ),
            )),
        f
            ? Container(
                width: WIDTH,
                child: Center(
                    child: RichText(
                  text: TextSpan(
                      text: c,
                      style: TextStyle(
                        fontFamily: '楷体',
                        color: Color(0xefff1e1e),
                        fontSize: adaptSize,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          _audioUrl = "assets/WrongWordAudio/" +
                              _py[0] +
                              "/" +
                              _py +
                              ".MP3";
                          print(_audioUrl);
                          await audioPlayer.setSourceUrl(_audioUrl);
                          await audioPlayer.resume();
                        }),
                )))
            : Container(
                width: WIDTH,
                child: Center(
                    child: RichText(
                  text: TextSpan(
                    text: c,
                    style: TextStyle(
                      fontFamily: '楷体',
                      color: Color(0xff2a2a2a),
                      fontSize: adaptSize,
                    ),
                  ),
                )))
      ],
    );
  }

  // 创造题目内容
  List<Widget> getRichText4Show(
      String str, String py, bool showWrongs, bool enablePinyin) {
    double WIDTH = 10.5;
    int ROWLEN = 15;
    int pyLen = py.length;
    py += "   ";
    List<String> pyList = List.empty(growable: true);
    String pyTmp = "";
    RegExp pyExp = RegExp(r"[A-Za-z0-9]");
    for (int i = 0; i < pyLen; ++i) {
      if (pyExp.hasMatch(py[i])) {
        pyTmp += py[i];
      } else {
        if (pyTmp != "") {
          pyList.add(pyTmp);
        }
        pyTmp = "";
      }
    }
    if (pyTmp != "") pyList.add(pyTmp);
    str += "\n";
    RegExp exp = RegExp(r"[\u4e00-\u9fa5]");
    List<Container> row = List.empty(growable: true);
    List<Widget> rows = List.empty(growable: true);
    List<bool> str_isWrong = List.filled(str.length, false);

    int c_str_len = 0;
    if (dataOneResultCard != null && dataOneResultCard!.dataOneWordCard != null)
      c_str_len = dataOneResultCard!.dataOneWordCard!.length;
    for (int i = 0, cnt = 0; i < str.length; ++i) {
      if (exp.hasMatch(str[i])) {
        // 是中文字
        if (cnt < c_str_len) {
          str_isWrong[i] = dataOneResultCard!.dataOneWordCard![cnt].isWrong!;
          print(str[i] +
              " 对比 " +
              dataOneResultCard!.dataOneWordCard![cnt].word! +
              " : " +
              str_isWrong[i].toString());
          cnt++;
        }
      }
    }
    bool centerFlag = false;
    for (int i = 0, cnt = 0; i < str.length; ++i) {
      if (i < 5) print(str[i]);
      if (str[i] == '#') {
        centerFlag = true;
        continue;
      }
      if (str[i] == '\n') {
        if (row.isNotEmpty) {
          if (centerFlag) {
            rows.add(Row(
                mainAxisAlignment: MainAxisAlignment.center, children: row));
          } else {
            rows.add(
                Row(mainAxisAlignment: MainAxisAlignment.start, children: row));
          }
        }
        row = List.empty(growable: true);
      } else {
        var c = str[i];
        bool f = showWrongs;
        row.add(Container(
            height: 30,
            child: getOneWord(
                c,
                exp.hasMatch(str[i]) && cnt < pyList.length ? pyList[cnt] : "",
                WIDTH,
                f && str_isWrong[i],
                enablePinyin)));
        if (exp.hasMatch(str[i])) cnt += 1;
        if (row.length == ROWLEN) {
          if (row.isNotEmpty) {
            if (centerFlag) {
              rows.add(Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: row));
            } else {
              rows.add(Row(
                  mainAxisAlignment: MainAxisAlignment.start, children: row));
            }
          }
          row = List.empty(growable: true);
        }
      }
      if (str[i] == '\n') centerFlag = false;
    }

    return rows;
  }

  Future<void> postAndGetResultXf(bool add2Mis) async {
    if (_filePath == '') {
      return;
    }
    _isUploading = true;
    dataOneResultCard =
        await MsgMgrQuestion().postAndGetResultXf(this, add2Mis);
    // 标定状态
    _isUploading = false;
  }
}

class ExamResult {
  double? totScore = 0;
  List<SubCpsrcds>? listSubCpsrcd;
  ExamResult({this.totScore, this.listSubCpsrcd});
}
