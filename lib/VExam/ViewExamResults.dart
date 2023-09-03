import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentShadowedContainer.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/VAppHome/ViewAppHome.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VExam/MsgQuestion.dart';

Future<Map<String, dynamic>> parseExamResults(http.Response response) async {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final retMap = decoded['data'];
  return retMap;
}

Future<ParsedResultsXf> parseAndPostResultsXf(
    List<DataQuestionPageMain> dataList, String id) async {
  final parsedResultsXf =
      ParsedResultsXf.fromQuestionPageDataList(dataList, id);
  await MsgMgrQuestion().postResultToServer(parsedResultsXf);
  return parsedResultsXf;
}

class ViewExamResult extends StatelessWidget {
  static const String routeName = 'fullExamResult';
  const ViewExamResult({super.key});

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
    rows.add(ComponentSubtitle(label: '$iconText情况', style: gSubtitleStyle0));
    if (wrongMap.isEmpty) {
      rows.add(ComponentTitle(
        label: '你没有读错的$iconText',
        style: gInfoTextStyle2,
      ));
    } else {
      List<TableRow> tableRows = List.empty(growable: true);
      tableRows.add(TableRow(children: [
        ComponentTitle(label: '错误$iconText', style: gInfoTextStyle2),
        ComponentTitle(label: '次数', style: gInfoTextStyle2),
        ComponentTitle(label: '错误字词', style: gInfoTextStyle2),
      ]));
      for (String wrongPhone in wrongMap.keys) {
        tableRows.add(TableRow(children: [
          ComponentTitle(label: wrongPhone, style: gInfoTextStyle2),
          ComponentTitle(
              label: wrongMap[wrongPhone]!.length.toString(),
              style: gInfoTextStyle2),
          ComponentTitle(
              label: getStringLabelFromWrongPhoneList(wrongMap[wrongPhone]!),
              style: gInfoTextStyle2),
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
      rows.add(Padding(padding: EdgeInsets.all(20.0), child: table));
    }
  }

  void _handleScoreList(List<Widget> rows, List<ItemResult> itemList) {
    rows.add(ComponentSubtitle(
      label: '各小题得分',
      style: gSubtitleStyle0,
    ));
    for (final item in itemList) {
      if(item.tNum == 1) {
        rows.add(ComponentTitle(
            label:
                '朗读词语 ${item.cNum} 得分${item.gotScore.toStringAsFixed(1)}/${item.fullScore.toStringAsFixed(1)}',
            style: gInfoTextStyle2));
      } else if(item.tNum == 2) {
        rows.add(ComponentTitle(
            label:
                '朗读短文 得分${item.gotScore.toStringAsFixed(1)}/${item.fullScore.toStringAsFixed(1)}',
            style: gInfoTextStyle2));
      }

    }
  }

  Widget _generateScaffoldBodyXf(ParsedResultsXf data) {
    if (data.resultList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            '您没有进行测试，不生成报告。',
            style: gSubtitleStyle,
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
      ComponentSubtitle(label: '全面测试结果', style: gTitleStyle),
      ComponentShadowedContainer(
        child: ComponentTitle(
            label:
                '您的得分:${data.weightedScore.toStringAsFixed(1)}/总分:${data.totalWeight}',
            style: gInfoTextStyle),
        color: gColor7BCBE6RGBA48,
        shadowColor: Color.fromARGB(0, 0, 0, 0),
        edgesHorizon: 38.5,
        edgesVertical: 12.0,
      ),
      ComponentShadowedContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ComponentTitle(
                label: '声调得分:${averageTone.toStringAsFixed(1)}',
                style: gInfoTextStyle),
            ComponentTitle(
                label: '发音得分:${averagePhone.toStringAsFixed(1)}',
                style: gInfoTextStyle),
            ComponentTitle(
                label: '流畅得分:${averageFluency.toStringAsFixed(1)}',
                style: gInfoTextStyle),
          ],
        ),
        color: gColorE8F3FBRGBA,
        shadowColor: Color(0x00000000),
        edgesHorizon: 38.5,
        edgesVertical: 12.0,
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            '增读:$sumMore, 漏读:$sumLess, 回读:$sumRetro, 替换:$sumRepl',
            style: gInfoTextStyle1,
          ),
        ),
      ),
    ]);
    List<Widget> _children = List.empty(growable: true);
    _handleScoreList(_children, data.itemList);
    _handleTable(_children, '声母', data.wrongShengs);
    _handleTable(_children, '韵母', data.wrongYuns);
    // 声调需要和声母韵母分开处理
    _children.add(
      ComponentSubtitle(
        label: '声调情况',
        style: gSubtitleStyle0,
      ),
    );
    if (data.wrongMonos.isEmpty) {
      _children.add(
        ComponentTitle(
          label: '你没有读错的声调。',
          style: gSubtitleStyle0,
        ),
      );
    } else {
      List<TableRow> tableRows = List.empty(growable: true);
      tableRows.add(TableRow(children: [
        ComponentTitle(label: '错误声调', style: gInfoTextStyle2),
        ComponentTitle(label: '次数', style: gInfoTextStyle2),
        ComponentTitle(label: '错误字词', style: gInfoTextStyle2),
      ]));
      for (String wrongMono in data.wrongMonos.keys) {
        tableRows.add(TableRow(children: [
          ComponentTitle(label: wrongMono, style: gInfoTextStyle2),
          ComponentTitle(
              label: data.wrongMonos[wrongMono]!.length.toString(),
              style: gInfoTextStyle2),
          ComponentTitle(
              label:
                  getStringLabelFromWrongMonoList(data.wrongMonos[wrongMono]!),
              style: gInfoTextStyle2),
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
      _children.add(Padding(padding: EdgeInsets.all(20.0), child: monoTable));
    }
    rows.add(
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(bottom: 84),
          child: ComponentShadowedContainer(
            color: Color(0xffffffff),
            shadowColor: Color.fromARGB(0, 0, 0, 0),
            edgesHorizon: 27,
            edgesVertical: 20,
            child: ListView(
              children: _children,
            ),
          ),
        ),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  Widget? _showEnterApp(BuildContext context, bool isShow) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          ComponentRoundButton(
            func: () => Navigator.pushNamed(context, ViewAppHome.routeName),
            color: gColorE3EDF7RGBA,
            child: ComponentTitle(
                label: isShow ? "进入APP" : "返回APP", style: gTitleStyle),
            height: 64,
            width: 200,
            radius: 6,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
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
            bottomSheet: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    ComponentRoundButton(
                      func: () =>
                          Navigator.pushNamed(context, args.endingRoute),
                      color: gColorE3EDF7RGBA,
                      child: ComponentTitle(label: '结束', style: gTitleStyle),
                      height: 64,
                      width: 200,
                      radius: 6,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
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
