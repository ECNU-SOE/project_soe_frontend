import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_soe/src/app_home/app_home.dart';

import 'package:project_soe/src/data/styles.dart';
import 'package:project_soe/src/data/exam_data.dart';
import 'package:project_soe/src/components/voice_input.dart';
import 'package:project_soe/src/login/authorition.dart';

Future<Map<String, dynamic>> parseExamResults(http.Response response) async {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final retMap = decoded['data'];
  return retMap;
}

Future<ParsedResultsXf> submitAndGetResultsXf(
    List<VoiceInputPage> inputPages, String id) async {
  return ParsedResultsXf.fromVoiceInputPageList(inputPages);
}

Future<Map<String, dynamic>> submitAndGetResults(
    List<VoiceInputPage> inputPages, String id) async {
  List<Map<String, dynamic>> dataList = [];
  int index = 0;
  for (VoiceInputPage inputPage in inputPages) {
    if (inputPage.questionPageData.resultData == null) {
      continue;
    }
    dataList.add(inputPage.questionPageData.resultData!.getJsonMap(index));
    index++;
  }
  if (dataList.isEmpty) {
    return {};
  }
  final bodyMap = {
    'cpsgrpId': id,
    'scores': dataList,
  };
  final client = http.Client();
  final token = AuthritionState.get().hasToken()
      ? AuthritionState.get().getToken()!
      : await AuthritionState.get().getTempToken();
  final response = await client.post(
    Uri.parse('http://47.101.58.72:8002/api/cpsgrp/v1/transcript'),
    body: jsonEncode(bodyMap).toString(),
    headers: {
      "Content-Type": "application/json",
      // FIXME 22.11.19 这里用的是临时Token
      'token': token,
    },
    encoding: Encoding.getByName('utf-8'),
  );
  return compute(parseExamResults, response);
}

class FullExaminationResult extends StatelessWidget {
  static const String routeName = 'fullExamResult';
  const FullExaminationResult({super.key});

  Widget _textWrap(String text, TextStyle textStyle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
        child: Text(text, style: textStyle),
      ),
    );
  }

  // TODO 23.3.5 实现这个转换
  String _pinyintoString(List<Map<String, dynamic>> labelList) {
    String ret = '';
    for (var word in labelList) {
      ret = ret + word['word'] + '(' + word['pinyin'] + ')';
    }
    return ret;
  }

  Widget _handleListItem(Map<String, dynamic>? data, String title) {
    String label = title;
    String example = _pinyintoString(data![title]['example']);
    String score = data[title]['score'].toString();
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                label,
                style: gExaminationResultTextStyle,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              example,
              style: gExaminationResultTextStyle,
            )
          ],
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 25.0),
              child: Text(
                score,
                style: gExaminationResultTextStyle,
              ),
            ),
          ],
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Widget _generateScaffoldBodyXf(ParsedResultsXf data) {
    if (data.resultList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            '您没有进行测试，不生成报告。',
            style: gExaminationResultSubtitleStyle,
          ),
        ),
      );
    }
    // double sumTotal = 0.0;
    double sumPhone = 0.0;
    double sumTone = 0.0;
    double sumFluency = 0.0;
    int sumMore = 0; // 增读
    int sumLess = 0; // 漏读
    int sumRetro = 0; // 回读
    int sumRepl = 0; // 替换
    for (final result in data.resultList) {
      // sumTotal += result.totalScore;
      sumPhone += result.phoneScore;
      sumTone += result.toneScore;
      sumFluency += result.fluencyScore;
      sumMore += result.more;
      sumLess += result.less;
      sumRetro += result.retro;
      sumRepl += result.repl;
    }
    // final averageTotal = sumTotal / data.resultList.length;
    final averagePhone = sumPhone / data.resultList.length;
    final averageTone = sumTone / data.resultList.length;
    final averageFluency = sumFluency / data.resultList.length;
    List<Widget> rows = List.empty(growable: true);
    rows.addAll([
      _textWrap('全面测试结果', gExaminationResultSubtitleStyle),
      _textWrap(
          '您的得分:${data.weightedScore.toStringAsFixed(1)}/总分:${data.totalWeight}',
          gExaminationResultSubtitleStyle),
      _textWrap('声调得分:$averageTone', gExaminationResultSubtitleStyle),
      _textWrap('发音得分:$averagePhone', gExaminationResultSubtitleStyle),
      _textWrap('流畅得分:$averageFluency', gExaminationResultSubtitleStyle),
      _textWrap('增读:$sumMore, 漏读:$sumLess, 回读:$sumRetro, 替换:$sumRepl',
          gExaminationResultTextStyle),
    ]);
    rows.add(_textWrap('你读错的声母', gExaminationResultSubtitleStyle));
    for (final resultDataXf in data.resultList) {
      for (final sheng in resultDataXf.wrongSheng) {
        rows.add(_textWrap(
            '${sheng.word}(${sheng.shengmu})', gExaminationResultTextStyle));
      }
    }
    rows.add(_textWrap('你读错的韵母', gExaminationResultSubtitleStyle));
    for (final resultDataXf in data.resultList) {
      for (final yun in resultDataXf.wrongYun) {
        rows.add(_textWrap(
            '${yun.word}(${yun.yunmu})', gExaminationResultTextStyle));
      }
    }
    rows.add(_textWrap('你读错的声调', gExaminationResultSubtitleStyle));
    for (final resultDataXf in data.resultList) {
      for (final monotone in resultDataXf.wrongMonotones) {
        rows.add(_textWrap(
            '${monotone.word}(${monotone.tone})', gExaminationResultTextStyle));
      }
    }
    final listView = ListView(
      children: rows,
    );
    return listView;
  }

  // 23.3.15 此函数弃用
  Widget? _generateScaffoldBody(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }
    if (data.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            '您没有进行测试，不生成报告。',
            style: gExaminationResultSubtitleStyle,
          ),
        ),
      );
    }
    List<Widget> rows = List.empty(growable: true);
    rows.addAll([
      _textWrap('全面测试结果', gExaminationResultSubtitleStyle),
      _textWrap('您的得分:${data['score']}', gExaminationResultSubtitleStyle),
      Row(
        children: [
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 10.0, top: 10.0, left: 20.0),
              child: Text('您的主要问题有', style: gExaminationResultSubtitleStyle),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    ]);
    final problems = data['problems'].toList();
    for (String problem in problems) {
      rows.add(
        Row(
          children: [
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 10.0, top: 10.0, left: 40.0),
                child: Text(problem, style: gExaminationResultTextStyle),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      );
    }
    rows.add(Row(
      children: [
        Column(
          children: [
            Container(
              height: 48,
              child: Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text(
                  '声母',
                  style: gExaminationResultSubtitleStyle,
                ),
              ),
            )
          ],
        ),
        Column(
          children: [
            Container(
              height: 48,
              child: Text('例字', style: gExaminationResultSubtitleStyle),
            )
          ],
        ),
        Column(
          children: [
            Container(
              height: 48,
              child: Padding(
                padding: EdgeInsets.only(right: 25.0),
                child: Text(
                  '评价',
                  style: gExaminationResultSubtitleStyle,
                ),
              ),
            )
          ],
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ));
    rows.add(_handleListItem(data['shengmu'], 'bpm'));
    rows.add(_handleListItem(data['shengmu'], 'f'));
    rows.add(_handleListItem(data['shengmu'], 'zcs'));
    rows.add(_handleListItem(data['shengmu'], 'dtnl'));
    // rows.add();

    final listView = Wrap(
      children: rows,
    );
    return listView;
    // final completion = data['pronCompletion'];
    // final accuracy = data['pronAccuracy'];
    // final fluency = data['pronFluency'];
    // final scoreLabel = '建议得分: $score/100';
    // final completionLabel = '完整度: $completion/10.0';
    // final accuracyLabel = '准确度: $accuracy/10.0';
    // final fluencyLabel = '流畅度: $fluency/10.0';
    // final listView = ListView(
    //   children: [
    //     _textWrap(scoreLabel, gExaminationResultSubtitleStyle),
    //     _textWrap(completionLabel, gExaminationResultTextStyle),
    //     _textWrap(accuracyLabel, gExaminationResultTextStyle),
    //     _textWrap(fluencyLabel, gExaminationResultTextStyle),
    //   ],
    // );
    // return listView;
  }

  Widget? _showEnterApp(BuildContext context, bool isShow) {
    return ElevatedButton(
      child: Text(isShow ? "进入APP" : "返回APP"),
      onPressed: () {
        Navigator.pushNamed(context, ApplicationHome.routeName);
      },
    );
  }

  // FIXME 23.3.5 此处用的是临时界面
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as FullExamResultScreenArguments;
    // return FutureBuilder<Map<String, dynamic>>(
    return FutureBuilder<ParsedResultsXf>(
      // future: submitAndGetResults(args.inputPages, args.id),
      future: submitAndGetResultsXf(args.inputPages, args.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return Scaffold(
            body: _generateScaffoldBodyXf(snapshot.data!),
            bottomNavigationBar: Container(
              child: ElevatedButton(
                child: const Text("进入APP"),
                onPressed: () {
                  Navigator.pushNamed(context, ApplicationHome.routeName);
                },
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
