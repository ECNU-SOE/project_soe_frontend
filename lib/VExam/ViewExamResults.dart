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
import 'package:project_soe/VCommon/DataTranscript.dart';
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

double allTotalScore = 0,
    allToneScore = 0,
    allFluencyScore = 0,
    allPhoneScore = 0;
List<double> totPhoneScore = [],
    totToneScore = [],
    totFluencyScore = [],
    totTotalScore = [];
List<String> totPhoneScoreName = [],
    totToneScoreName = [],
    totFluencyScoreName = [],
    totTotalScoreName = [];

int allMore = 0, allLess = 0, allRepl = 0, allRetro = 0;
List<int> totLess = [], totMore = [], totRepl = [], totRetro = [];
List<String> keyValueName = [];

Future<void> parseAndPostResultsXf(
    String id,
    double suggestedScore,
    List<String> yunMuName,
    List<String> yunMuNum,
    List<String> shengMuName,
    List<String> shengMuNum) async {
  String resJson = "";
  resJson += "{";

  resJson += '"suggestedScore":' + suggestedScore.toString() + ",";
  resJson += '"allTotalScore":' + allTotalScore.toString() + ",";
  resJson += '"allPhoneScore":' + allPhoneScore.toString() + ",";
  resJson += '"allToneScore":' + allToneScore.toString() + ",";
  resJson += '"allFluencyScore":' + allFluencyScore.toString() + ",";
  resJson += '"allLess":' + allLess.toString() + ",";
  resJson += '"allMore":' + allMore.toString() + ",";
  resJson += '"allRepl":' + allRepl.toString() + ",";
  resJson += '"allRetro":' + allRetro.toString() + ",";

  resJson += '"totPhoneScore":[';
  for (int i = 1; i < keyValueName.length; ++i) {
    resJson += "{";
    resJson += '"name":"' + keyValueName[i] + '",';
    resJson += '"score":' + totPhoneScore[i].toString();
    resJson += "}";
    if (i != keyValueName.length - 1) resJson += ",";
  }
  resJson += "],";

  resJson += '"totToneScore":[';
  for (int i = 1; i < keyValueName.length; ++i) {
    resJson += "{";
    resJson += '"name":"' + keyValueName[i] + '",';
    resJson += '"score":' + totToneScore[i].toString();
    resJson += "}";
    if (i != keyValueName.length - 1) resJson += ",";
  }
  resJson += "],";

  resJson += '"totFluencyScore":[';
  for (int i = 1; i < keyValueName.length; ++i) {
    resJson += "{";
    resJson += '"name":"' + keyValueName[i] + '",';
    resJson += '"score":' + totFluencyScore[i].toString();
    resJson += "}";
    if (i != keyValueName.length - 1) resJson += ",";
  }
  resJson += "],";

  resJson += '"totTotalScore":[';
  for (int i = 1; i < keyValueName.length; ++i) {
    resJson += "{";
    resJson += '"name":"' + keyValueName[i] + '",';
    resJson += '"score":' + totTotalScore[i].toString();
    resJson += "}";
    if (i != keyValueName.length - 1) resJson += ",";
  }
  resJson += "],";



    resJson += '"totLess":[';
  for (int i = 1; i < keyValueName.length; ++i) {
    resJson += "{";
    resJson += '"name":"' + keyValueName[i] + '",';
    resJson += '"num":' + totLess[i].toString();
    resJson += "}";
    if (i != keyValueName.length - 1) resJson += ",";
  }
  resJson += "],";

    resJson += '"totMore":[';
  for (int i = 1; i < keyValueName.length; ++i) {
    resJson += "{";
    resJson += '"name":"' + keyValueName[i] + '",';
    resJson += '"num":' + totMore[i].toString();
    resJson += "}";
    if (i != keyValueName.length - 1) resJson += ",";
  }
  resJson += "],";

    resJson += '"totRepl":[';
  for (int i = 1; i < keyValueName.length; ++i) {
    resJson += "{";
    resJson += '"name":"' + keyValueName[i] + '",';
    resJson += '"num":' + totRepl[i].toString();
    resJson += "}";
    if (i != keyValueName.length - 1) resJson += ",";
  }
  resJson += "],";

    resJson += '"totRetro":[';
  for (int i = 1; i < keyValueName.length; ++i) {
    resJson += "{";
    resJson += '"name":"' + keyValueName[i] + '",';
    resJson += '"num":' + totRetro[i].toString();
    resJson += "}";
    if (i != keyValueName.length - 1) resJson += ",";
  }
  resJson += "],";


  resJson += '"wrongShengMu":[';
  for (int i = 0; i < shengMuName.length; ++i) {
    resJson += "{";
    resJson += '"name":"' + shengMuName[i] + '",';
    resJson += '"num":' + shengMuNum[i].toString();
    resJson += "}";
    if (i != shengMuName.length - 1) resJson += ",";
  }
  resJson += "],";

  resJson += '"wrongYunMu":[';
  for (int i = 0; i < yunMuName.length; ++i) {
    resJson += "{";
    resJson += '"name":"' + yunMuName[i] + '",';
    resJson += '"num":' + yunMuNum[i].toString();
    resJson += "}";
    if (i != yunMuName.length - 1) resJson += ",";
  }
  resJson += "]";

  resJson += "}";
  print(resJson);

  // await MsgMgrQuestion().postResultToServer(resJson, id, suggestedScore);
  // final parsedResultsXf =
  //     ParsedResultsXf.fromQuestionPageDataList(dataList, id);

  // await MsgMgrQuestion().postResultToServer(parsedResultsXf);

  // return parsedResultsXf;
}

class _generateBody extends StatelessWidget {
  final String id;
  final double totScore;
  final List<DataOneResultCard> dataList;
  final String endingRoute;
  final Map<dynamic, String> idx2Name;
  final Map<dynamic, double> idx2Score;
  final Map<dynamic, int> type2Idx;
  final Map<dynamic, dynamic> index2Name;
  final Map<dynamic, dynamic> index2Score;

  _generateBody(
      {required this.id,
      required this.totScore,
      required this.dataList,
      required this.endingRoute,
      required this.idx2Name,
      required this.idx2Score,
      required this.type2Idx,
      required this.index2Name,
      required this.index2Score});

  Map<String, int> wrongShengMuCount = {}, wrongYunMuCount = {};

  @override
  Widget build(BuildContext context) {
    totPhoneScore.clear();
    totToneScore.clear();
    totFluencyScore.clear();
    totTotalScore.clear();
    totLess.clear();
    totMore.clear();
    totRepl.clear();
    totRetro.clear();
    keyValueName.clear();
    allFluencyScore = allToneScore = allPhoneScore = allTotalScore = 0;
    allLess = allMore = allRepl = allRetro = 0;
    for (int i = 0; i <= type2Idx.length; ++i) {
      totPhoneScore.add(0);
      totToneScore.add(0);
      totFluencyScore.add(0);
      totTotalScore.add(0);
      totLess.add(0);
      totMore.add(0);
      totRepl.add(0);
      totRetro.add(0);
      totPhoneScoreName.add("");
      totToneScoreName.add("");
      totFluencyScoreName.add("");
      totTotalScoreName.add("");
      keyValueName.add("");
    }
    for (var dataOneResultCard in dataList) {
      String tmpDescription = dataOneResultCard.description ?? "";
      totPhoneScore[type2Idx[tmpDescription] ?? 0] +=
          dataOneResultCard.phoneScore ?? 0;
      totToneScore[type2Idx[tmpDescription] ?? 0] +=
          dataOneResultCard.toneScore ?? 0;
      totFluencyScore[type2Idx[tmpDescription] ?? 0] +=
          dataOneResultCard.fluencyScore ?? 0;
      totTotalScore[type2Idx[tmpDescription] ?? 0] +=
          dataOneResultCard.totalScore ?? 0;
      totMore[type2Idx[tmpDescription] ?? 0] += dataOneResultCard.more ?? 0;
      totLess[type2Idx[tmpDescription] ?? 0] += dataOneResultCard.less ?? 0;
      totRepl[type2Idx[tmpDescription] ?? 0] += dataOneResultCard.repl ?? 0;
      totRetro[type2Idx[tmpDescription] ?? 0] += dataOneResultCard.retro ?? 0;

      if (dataOneResultCard.dataOneWordCard == null) continue;
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

    List<DataRow> shengMuList = List.empty(growable: true);
    List<String> shengMuName = List.empty(growable: true);
    List<String> shengMuNum = List.empty(growable: true);
    wrongShengMuCount.forEach((key, value) {
      if (key != " ") {
        shengMuName.add(key);
        shengMuNum.add(value.toString());
        shengMuList.add(DataRow(
            cells: [DataCell(Text(key)), DataCell(Text(value.toString()))]));
      }
    });

    List<DataRow> yunMuList = List.empty(growable: true);
    List<String> yunMuName = List.empty(growable: true);
    List<String> yunMuNum = List.empty(growable: true);
    wrongYunMuCount.forEach((key, value) {
      if (key != " ") {
        yunMuName.add(key);
        yunMuNum.add(value.toString());
        yunMuList.add(DataRow(
            cells: [DataCell(Text(key)), DataCell(Text(value.toString()))]));
      }
    });

    type2Idx.forEach((key, value) {
      if (key != "") {
        allTotalScore += totTotalScore[value];
        allToneScore += totToneScore[value];
        allFluencyScore += totFluencyScore[value];
        allPhoneScore += totPhoneScore[value];
        allMore += totMore[value];
        allLess += totLess[value];
        allRepl += totRepl[value];
        allRetro += totRetro[value];
        keyValueName[value] = key;
      }
    });

    List<DataRow> scores = List.empty(growable: true);
    List<DataRow> mlpp = List.empty(growable: true);
    scores.add(DataRow(cells: [
      DataCell(Text("总成绩")),
       DataCell(Text("${allTotalScore}/${totScore}")),
      DataCell(Text("${allToneScore}")),
      DataCell(Text("${allPhoneScore}")),
      DataCell(Text("${allFluencyScore}")),
    ]));
    mlpp.add(DataRow(cells: [
      DataCell(Text("总")),
      DataCell(Text("${allMore}")),
      DataCell(Text("${allLess}")),
      DataCell(Text("${allRetro}")),
      DataCell(Text("${allRepl}"))
    ]));
    type2Idx.forEach((key, value) {
      if (key != "") {
        scores.add(DataRow(cells: [
          DataCell(Text(value.toString() + "." + key)),
          DataCell(Text("${totTotalScore[value]}/${idx2Score[key]}")),
          DataCell(Text("${totToneScore[value]}")),
          DataCell(Text("${totPhoneScore[value]}")),
          DataCell(Text("${totFluencyScore[value]}")),
        ]));
        mlpp.add(DataRow(cells: [
          DataCell(Text(value.toString() + "." + key)),
          DataCell(Text("${totMore[value]}")),
          DataCell(Text("${totLess[value]}")),
          DataCell(Text("${totRetro[value]}")),
          DataCell(Text("${totRepl[value]}"))
        ]));
      }
    });

    parseAndPostResultsXf(
                id, 0, yunMuName, yunMuNum, shengMuName, shengMuNum);

    return 
    Padding(padding: EdgeInsets.only(top: 10), child: 
    ListView(children: [
      ComponentSubtitle(label: '全面测试结果', style: gTitleStyle),
      Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.grey.shade300),
              border: TableBorder.all(),
              columns: [
                DataColumn(label: Text("题型", style: gInfoTextStyle2)),
                DataColumn(label: Text("总分", style: gInfoTextStyle2)),
                DataColumn(label: Text("声调得分", style: gInfoTextStyle2)),
                DataColumn(label: Text("发音得分", style: gInfoTextStyle2)),
                DataColumn(label: Text("流畅得分", style: gInfoTextStyle2)),
                // DataColumn(label: Text("增读", style: gInfoTextStyle2)),
                // DataColumn(label: Text("漏读", style: gInfoTextStyle2)),
                // DataColumn(label: Text("回读", style: gInfoTextStyle2)),
                // DataColumn(label: Text("替换", style: gInfoTextStyle2)),
              ],
              rows: scores)),
            Padding(
          padding: EdgeInsets.only(top:10, left: 20, right: 20),
          child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.grey.shade300),
              border: TableBorder.all(),
              columns: [
                DataColumn(label: Text("题型", style: gInfoTextStyle2)),
                DataColumn(label: Text("增读", style: gInfoTextStyle2)),
                DataColumn(label: Text("漏读", style: gInfoTextStyle2)),
                DataColumn(label: Text("回读", style: gInfoTextStyle2)),
                DataColumn(label: Text("替换", style: gInfoTextStyle2)),
              ],
              rows: mlpp)),
      Padding(
         padding: EdgeInsets.only(top:10, left: 20, right: 20),
          child: Container(
            height: 300,
            child: ListView(
              children: [
                DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.shade300),
                    border: TableBorder.all(),
                    columns: [
                      DataColumn(
                        label: Text(
                          "声母错误",
                          style: gInfoTextStyle2,
                        ),
                      ),
                      DataColumn(
                        label: Text("次数"),
                      )
                    ],
                    rows: shengMuList)
              ],
            ),
          )),
      Padding(
          padding: EdgeInsets.all(5.0),
          child: Container(
            height: 300,
            child: ListView(
              children: [
                DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.shade300),
                    border: TableBorder.all(),
                    columns: [
                      DataColumn(
                        label: Text(
                          "韵母错误",
                          style: gInfoTextStyle2,
                        ),
                      ),
                      DataColumn(
                        label: Text("次数"),
                      )
                    ],
                    rows: yunMuList)
              ],
            ),
          )),
    ],),)
    ;
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
      body: _generateBody(
          id: args.id,
          totScore: args.sumScore,
          dataList: args.dataList,
          endingRoute: args.endingRoute,
          idx2Name: args.idx2Name,
          idx2Score: args.idx2Score,
          type2Idx: args.type2Idx,
          index2Name: args.index2Name,
          index2Score: args.index2Score),
          bottomNavigationBar:       Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: ComponentRoundButton(
          func: () {
            // parseAndPostResultsXf(
            //     args.id, 0, yunMuName, yunMuNum, shengMuName, shengMuNum);
            Navigator.pushNamed(context, args.endingRoute);
          },
          color: gColorE3EDF7RGBA,
          child: ComponentTitle(label: '结束', style: gTitleStyle),
          height: 64,
          width: 200,
          radius: 6,
        ),
      ),
    );
  }
}
