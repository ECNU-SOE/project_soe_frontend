import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:project_soe/src/VAppHome/ViewAppHome.dart';

import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/VExam/DataQuestion.dart';
import 'package:project_soe/src/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/src/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/src/VExam/MsgQuestion.dart';

Future<Map<String, dynamic>> parseExamResults(http.Response response) async {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final retMap = decoded['data'];
  return retMap;
}

Future<ParsedResultsXf> parseAndPostResultsXf(
    List<DataQuestionPageMain> dataList, String id) async {
  final parsedResultsXf = ParsedResultsXf.fromQuestionPageDataList(dataList);
  await MsgMgrQuestion().postResultToServer(parsedResultsXf);
  return parsedResultsXf;
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

  TableCell _tableTextWrap(String text, TextStyle textStyle) {
    return TableCell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(text, style: textStyle),
        ),
      ),
    );
  }

  void _handleTable(List<Widget> rows, String iconText,
      Map<String, List<WrongPhone>> wrongMap) {
    rows.add(_textWrap('$iconText情况', gViewExamResultSubtitleStyle));
    if (wrongMap.isEmpty) {
      rows.add(_textWrap('你没有读错的$iconText', gViewExamResultSubtitleStyle));
    } else {
      List<TableRow> tableRows = List.empty(growable: true);
      tableRows.add(TableRow(children: [
        _tableTextWrap('错误$iconText', gViewExamResultTextStyle),
        _tableTextWrap('次数', gViewExamResultTextStyle),
        _tableTextWrap('错误字词', gViewExamResultTextStyle),
      ]));
      for (String wrongPhone in wrongMap.keys) {
        tableRows.add(TableRow(children: [
          _tableTextWrap(wrongPhone, gViewExamResultTextStyle),
          _tableTextWrap(wrongMap[wrongPhone]!.length.toString(),
              gViewExamResultTextStyle),
          _tableTextWrap(
              getStringLabelFromWrongPhoneList(wrongMap[wrongPhone]!),
              gViewExamResultTextStyle),
        ]));
      }
      final table = Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(72),
          1: FixedColumnWidth(48),
          2: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: tableRows,
      );
      rows.add(table);
    }
  }

  Widget _generateScaffoldBodyXf(ParsedResultsXf data) {
    if (data.resultList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            '您没有进行测试，不生成报告。',
            style: gViewExamResultSubtitleStyle,
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
      _textWrap('全面测试结果', gViewExamResultSubtitleStyle),
      _textWrap(
          '您的得分:${data.weightedScore.toStringAsFixed(1)}/总分:${data.totalWeight}',
          gViewExamResultSubtitleStyle),
      _textWrap('声调得分:${averageTone.toStringAsFixed(1)}',
          gViewExamResultSubtitleStyle),
      _textWrap('发音得分:${averagePhone.toStringAsFixed(1)}',
          gViewExamResultSubtitleStyle),
      _textWrap('流畅得分:${averageFluency.toStringAsFixed(1)}',
          gViewExamResultSubtitleStyle),
      _textWrap('增读:$sumMore, 漏读:$sumLess, 回读:$sumRetro, 替换:$sumRepl',
          gViewExamResultTextStyle),
    ]);
    _handleTable(rows, '声母', data.wrongShengs);
    _handleTable(rows, '韵母', data.wrongYuns);
    // 声调需要和声母韵母分开处理
    rows.add(_textWrap('声调情况', gViewExamResultSubtitleStyle));
    if (data.wrongMonos.isEmpty) {
      rows.add(_textWrap('你没有读错的声调。', gViewExamResultSubtitleStyle));
    } else {
      List<TableRow> tableRows = List.empty(growable: true);
      tableRows.add(TableRow(children: [
        _tableTextWrap('错误声调', gViewExamResultTextStyle),
        _tableTextWrap('次数', gViewExamResultTextStyle),
        _tableTextWrap('错误字词', gViewExamResultTextStyle),
      ]));
      for (String wrongMono in data.wrongMonos.keys) {
        tableRows.add(TableRow(children: [
          _tableTextWrap(wrongMono, gViewExamResultTextStyle),
          _tableTextWrap(data.wrongMonos[wrongMono]!.length.toString(),
              gViewExamResultTextStyle),
          _tableTextWrap(
              getStringLabelFromWrongMonoList(data.wrongMonos[wrongMono]!),
              gViewExamResultTextStyle),
        ]));
      }
      final monoTable = Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(72),
          1: FixedColumnWidth(48),
          2: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: tableRows,
      );
      rows.add(monoTable);
    }
    final listView = ListView(
      children: rows,
    );
    return listView;
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
    final args =
        ModalRoute.of(context)!.settings.arguments as ArgsViewExamResult;
    return FutureBuilder<ParsedResultsXf>(
      future: parseAndPostResultsXf(args.dataList, args.id),
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
                child: const Text("结束"),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, args.endingRoute);
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
