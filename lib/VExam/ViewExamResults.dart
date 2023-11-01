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
import 'package:project_soe/VCommon/DataAllResultsCard.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VExam/MsgQuestion.dart';

// Future<Map<String, dynamic>> parseExamResults(http.Response response) async {
//   final u8decoded = utf8.decode(response.bodyBytes);
//   final decoded = jsonDecode(u8decoded);
//   final retMap = decoded['data'];
//   return retMap;
// }

// Future<DataAllResultCard> parseAndPostResultsXf(
//     List<DataQuestionPageMain> dataList, String id) async {
//   final parsedResultsXf =
//       ParsedResultsXf.fromQuestionPageDataList(dataList, id);

//   await MsgMgrQuestion().postResultToServer(parsedResultsXf);

//   return parsedResultsXf;
// }

class _generateBody extends StatelessWidget {
  final double totScore;
  final List<DataOneResultCard> dataList;
  _generateBody({required this.totScore, required this.dataList});

  double totPhoneScore = 0;
  double totToneScore = 0;
  double totFluencyScore = 0;
  double totTotalScore = 0;
  int totLess = 0;
  int totMore = 0;
  int totRepl = 0;
  int totRetro = 0;

  Map<String, int> wrongShengMuCount = {}, wrongYunMuCount = {};
  
  @override
  Widget build(BuildContext context) {
    for (var dataOneResultCard in dataList) {
      this.totPhoneScore += dataOneResultCard.phoneScore ?? 0;
      this.totToneScore += dataOneResultCard.toneScore ?? 0;
      this.totFluencyScore += dataOneResultCard.fluencyScore ?? 0;
      this.totTotalScore += dataOneResultCard.totalScore ?? 0;
      this.totMore += dataOneResultCard.more ?? 0;
      this.totLess += dataOneResultCard.less ?? 0;
      this.totRepl += dataOneResultCard.repl ?? 0;
      this.totRetro += dataOneResultCard.retro ?? 0;
      if(dataOneResultCard.dataOneWordCard == null) continue;
      for (int i = 0; i < dataOneResultCard.dataOneWordCard!.length; ++i) {
        DataOneWordCard x = dataOneResultCard.dataOneWordCard![i];
        if (x.isWrong == true &&
            x.wrongShengDiao == false &&
            x.wrongShengMu == false &&
            x.wrongYunMu == false) continue;
        if (x.wrongShengMu == true || x.wrongShengDiao == true) {
          if (wrongShengMuCount.containsKey(x.shengMu ?? "")) {
            int num = wrongShengMuCount[x.shengMu ?? ""] ?? 0;
            wrongShengMuCount[x.shengMu ?? ""] = num + 1;
          } else {
            wrongShengMuCount[x.shengMu ?? ""] = 1;
          }
        }
        if (x.wrongYunMu == true) {
          if (wrongYunMuCount.containsKey(x.yunMu ?? "")) {
            int num = wrongYunMuCount[x.yunMu ?? ""] ?? 0;
            wrongYunMuCount[x.yunMu ?? ""] = num + 1;
          } else {
            wrongYunMuCount[x.yunMu ?? ""] = 1;
          }
        }
      }
    }

    List<Widget> shengMuList = List.empty(growable: true);
    List<String> shengMuName = List.empty(growable: true);
    List<String> shengMuNum = List.empty(growable: true);
    shengMuName.add("错误的声母");
    shengMuNum.add("错误的数量");
    wrongShengMuCount.forEach((key, value) {
      if(key != " ") { 
        shengMuName.add(key);
        shengMuNum.add(value.toString());
      }
    });

    List<Widget> yunMuList = List.empty(growable: true);
    List<String> yunMuName = List.empty(growable: true);
    List<String> yunMuNum = List.empty(growable: true);
    yunMuName.add("错误的韵母");
    yunMuNum.add("错误的数量");
    wrongYunMuCount.forEach((key, value) {
      if(key != " ") {
        yunMuName.add(key);
        yunMuNum.add(value.toString());
      }
    });


    return 
    ListView(children: [
      ComponentSubtitle(label: '全面测试结果', style: gTitleStyle),
      ComponentShadowedContainer(
        child: ComponentTitle(
            label: '您的得分:0/总分:${totScore}', style: gInfoTextStyle),
        color: gColor7BCBE6RGBA48,
        shadowColor: Color.fromARGB(0, 0, 0, 0),
        edgesHorizon: 38.5,
        edgesVertical: 12.0,
      ),
      Padding(
        padding: EdgeInsets.all(5.0),
        child: DataTable(
          border: TableBorder.all(),
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text(totToneScore.toStringAsFixed(2))),
                DataCell(Text(totPhoneScore.toStringAsFixed(2))),
                DataCell(Text(totFluencyScore.toStringAsFixed(2))),
                DataCell(Text(totTotalScore.toStringAsFixed(2))),
              ],
            ),
          ],
          columns: <DataColumn>[
            DataColumn(label: Text('声调得分')),
            DataColumn(label: Text('发音得分')),
            DataColumn(label: Text('流畅得分')),
            DataColumn(label: Text('答题得分')),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.all(5.0),
        child: DataTable(
          border: TableBorder.all(),
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text(totMore.toString())),
                DataCell(Text(totLess.toString())),
                DataCell(Text(totRetro.toString())),
                DataCell(Text(totRepl.toString())),
              ],
            ),
          ],
          columns: <DataColumn>[
            DataColumn(label: Text('增读')),
            DataColumn(label: Text('漏读')),
            DataColumn(label: Text('回读')),
            DataColumn(label: Text('替换')),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.all(5.0),
        child: ListView(
          children: [
            DataTable(
                columns: [
                  DataColumn(
                    label: Text("标题"),
                  ),
                  DataColumn(
                    label: Text("作者"),
                  )
                ],
                rows: [
                  DataRow(
                    cells: [DataCell(Text("西游记")), DataCell(Text("吴承恩"))]),
                  DataRow(cells: [DataCell(Text("红楼梦")), DataCell(Text("曹雪芹"))]),
                ])
          ],
        )
      ),
    ]);
  }
}

class ViewExamResult extends StatelessWidget {
  static const String routeName = 'fullExamResult';
  const ViewExamResult({super.key});

  // FIXME 23.3.5 此处用的是临时界面
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ArgsViewExamResult;
    return Scaffold(
      body: _generateBody(totScore: args.sumScore, dataList: args.dataList),
      bottomSheet: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              ComponentRoundButton(
                func: () => Navigator.pushNamed(context, args.endingRoute),
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
  }
}
