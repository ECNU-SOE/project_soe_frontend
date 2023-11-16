import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/VAppHome/ViewAppHome.dart';
import 'package:project_soe/VCommon/DataAllResultsCard.dart';
import 'package:project_soe/VExam/MsgQuestion.dart';
import 'package:project_soe/VExam/ViewExamResults.dart';
import 'package:project_soe/VNativeLanguageChoice/ViewNativeLanguageChoice.dart';
import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/LabelText.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/s_o_e_icons_icons.dart';
import 'package:provider/provider.dart';

Map<dynamic, String> idx2Name = {
  1: "一、",
  2: "二、",
  3: "三、",
  4: "四、",
  5: "五、",
  6: "六、",
  7: "七、",
  8: "八、",
  9: "九、",
  10: "十、",
  11: "十一、",
  "1": "一、",
  "2": "二、",
  "3": "三、",
  "4": "四、",
  "5": "五、",
  "6": "六、",
  "7": "七、",
  "8": "八、",
  "9": "九、",
  "10": "十、",
  "11": "十一、",
  "": ""
};
Map<dynamic, double> idx2Score = {"": 0};
Map<dynamic, int> type2Idx = {};
Map<dynamic, dynamic> index2Name = {}, index2Score = {};
int typeNum = 0;

class _ViewExamBodyState extends State<_ViewExamBody> {
  _ViewExamBodyState();
  int _index = 0;
  int _listSize = 0;
  List<PopupMenuEntry<int>> popupMenuItem = [];
  ComponentVoiceInput? _inputPage;
  List<ComponentVoiceInput>? _voiceInputs;
  final ValueNotifier<double> _process = ValueNotifier<double>(0.0);

  void _onExitClick() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            child: Text(
              "确定",
              style: gInfoTextStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              '取消',
              style: gInfoTextStyle,
            ),
          ),
        ],
        content: Container(
          height: 52.0,
          child: Text(
            "你还没有提交, 确定要退出吗?",
            style: gInfoTextStyle,
          ),
        ),
      ),
    );
    return;
  }

  void _forward() {
    if (_index <= 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 48.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // CircularProgressIndicator(),
                Column(
                  children: [
                    Text(
                      "已达到第一题.",
                      style: gInfoTextStyle,
                    ),
                    Text(
                      '(点击空白处关闭提示)',
                      style: gInfoTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      return;
    } else {
      if (_voiceInputs == null) {
        return;
      }
      if (_voiceInputs![_index].dataPage.isRecording()) {
        return;
      }
      setState(() {
        _index = _index - 1;
        _process.value = _index.toDouble() / _listSize.toDouble();
      });
    }
  }

  void _next() {
    if (_index >= (_listSize - 1)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 48.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "已达到最后一题.",
                      style: gInfoTextStyle,
                    ),
                    Text(
                      '(点击空白处关闭提示)',
                      style: gInfoTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      return;
    } else {
      if (_voiceInputs == null) {
        return;
      }
      if (_voiceInputs![_index].dataPage.isRecording()) {
        return;
      }
      setState(() {
        _index = _index + 1;
        _process.value = _index.toDouble() / _listSize.toDouble();
      });
    }
  }

  void onSubmitButtonPressed() {
    if (_checkAnyUploading()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
            height: 48.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(),
                Column(
                  children: [
                    Text(
                      "请等待语音评测完成.",
                      style: gInfoTextStyle,
                    ),
                    Text(
                      '(点击空白处关闭提示)',
                      style: gInfoTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      int cnt = 0;
      List<DataOneResultCard> lst = List.empty(growable: true);
      for (final voiceInput in _voiceInputs!) {
        if (voiceInput.dataPage.dataOneResultCard == null) {
          RegExp exp = RegExp(r"[\u4e00-\u9fa5]");
          int less = 0;
          List<DataOneWordCard> listDataOneWord = List.empty(growable: true);
          for (int i = 0; i < voiceInput.dataPage.refText!.length; ++i) {
            if (exp.hasMatch(voiceInput.dataPage.refText![i])) {
              less++;
              DataOneWordCard tmp = DataOneWordCard(
                  isWrong: true,
                  wrongShengDiao: false,
                  wrongShengMu: false,
                  wrongYunMu: false);
              listDataOneWord.add(tmp);
            }
          }
          DataOneResultCard tmp = DataOneResultCard(
              cpsrcdId: voiceInput.dataPage.id,
              tNum: voiceInput.dataPage.tNum,
              cNum: voiceInput.dataPage.cNum,
              totalScore: 0,
              toneScore: 0,
              phoneScore: 0,
              more: 0,
              less: less,
              repl: 0,
              retro: 0,
              dataOneWordCard: listDataOneWord,
              tags: voiceInput.dataPage.tags,
              description: voiceInput.dataPage.title);
          voiceInput.dataPage.dataOneResultCard = tmp;
        } else
          cnt++;
        lst.add(voiceInput.dataPage.dataOneResultCard!);
      }
      if (cnt == 0) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(
                child: Text(
                  "确定",
                  style: gInfoTextStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '取消',
                  style: gInfoTextStyle,
                ),
              ),
            ],
            content: Container(
              height: 52.0,
              child: Text(
                "你还没有提交, 确定要退出吗?",
                style: gInfoTextStyle,
              ),
            ),
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, ViewExamResult.routeName,
            arguments: (ArgsViewExamResult(
                widget._args.cprsgrpId,
                lst,
                widget._args.endingRoute,
                widget._args.sumScore,
                idx2Name,
                idx2Score,
                type2Idx,
                index2Name,
                index2Score)));
      }
    }
  }

  bool _checkAnyUploading() {
    if (_voiceInputs == null || _voiceInputs!.isEmpty) {
      return false;
    }
    for (var voiceInput in _voiceInputs!) {
      if (voiceInput.dataPage.isUploading()) {
        return true;
      }
    }
    return false;
  }

  Widget _buildBottomWidget() {
    if (_index == (_listSize - 1)) {
      return Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
          child: ComponentRoundButton(
            func: onSubmitButtonPressed,
            color: gColorE3EDF7RGBA,
            child: ComponentTitle(label: '提   交', style: gSubtitleStyle),
            height: 64,
            width: 200,
            radius: 6,
          ),
        ),
        color: gColorE3EDF7RGBA,
      );
    } else {
      return LinearProgressIndicator(
        value: _process.value,
      );
    }
  }

  @override
  void initState() {
    _voiceInputs = List<ComponentVoiceInput>.empty(growable: true);
    super.initState();
    type2Idx.clear();
    index2Name.clear();
    index2Score.clear();

    typeNum = 0;
    for (var x in widget._dataList) {
      // x.type ??= "";
      print("--------");
      print(x.title);
      if (type2Idx.containsKey(x.title)) {
        continue;
      }
      type2Idx[x.title] = typeNum + 1;
      idx2Score[x.title] = 0;
      typeNum += 1;
    }
    for (int i = 0; i < widget._dataList.length; ++i) {
      index2Name[i] = idx2Name[type2Idx[widget._dataList[i].title]];
      idx2Score[widget._dataList[i].title] =
          idx2Score[widget._dataList[i].title]! +
              (widget._dataList[i].score ?? 0);
    }
    for (int i = 0; i < widget._dataList.length; ++i) {
      index2Score[i] = idx2Score[widget._dataList[i].title];
      print(index2Score[i]);
    }
    _listSize = widget._dataList.length;

    for (int i = 0; i < _listSize; ++i) {
      _inputPage = ComponentVoiceInput(
          dataPage: widget._dataList[i],
          wrongsShow: false,
          add2Mis: true,
          subButShow: false,
          questionNum: _listSize,
          nowIdx: i + 1,
          typeIdx: index2Name[i],
          typeScore: "（" + (index2Score[i] ?? 0).toString() + "分）",
          description: widget._dataList[i].title ?? "");
      try {
        _voiceInputs![i] = _inputPage!;
      } catch (e) {
        _voiceInputs!.add(_inputPage!);
      }
      PopupMenuEntry<int> item = PopupMenuItem(
          value: i,
          child: Container(
            width: 300,
            child: Row(
              children: [
                Container(
                    width: 200,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Text(
                        "第${i + 1}题: " + (widget._dataList[i].refText ?? ""),
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'SourceSerif',
                          fontSize: 12.0,
                        ),
                        softWrap: true,
                        maxLines: 1,
                      ),
                    )),
                Container(
                    width: 50,
                    color: _voiceInputs![i].dataPage.dataOneResultCard != null
                        ? Colors.green
                        : Colors.red,
                    child: Padding(
                        padding: EdgeInsets.all(4),
                        child: ComponentTitle(
                            label:
                                _voiceInputs![i].dataPage.dataOneResultCard !=
                                        null
                                    ? "已答"
                                    : "未答",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontFamily: 'SourceSerif',
                              fontSize: 16.0,
                            ))))
              ],
            ),
          ));
      try {
        popupMenuItem![i] = item;
      } catch (e) {
        popupMenuItem!.add(item);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _inputPage = ComponentVoiceInput(
        dataPage: widget._dataList[_index],
        wrongsShow: false,
        add2Mis: true,
        subButShow: false,
        questionNum: _listSize,
        nowIdx: _index + 1,
        typeIdx: index2Name[_index],
        typeScore: "（" + (index2Score[_index] ?? 0).toString() + "分）",
        description: widget._dataList[_index].title ?? "");
    try {
      _voiceInputs![_index] = _inputPage!;
    } catch (e) {
      _voiceInputs!.add(_inputPage!);
    }

    for (int i = 0; i < _listSize; ++i) {
      PopupMenuEntry<int> item = PopupMenuItem(
          value: i,
          child: Container(
            width: 300,
            child: Row(
              children: [
                Container(
                    width: 200,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Text(
                        "第${i + 1}题: " + (widget._dataList[i].refText ?? ""),
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'SourceSerif',
                          fontSize: 12.0,
                        ),
                        softWrap: true,
                        maxLines: 1,
                      ),
                    )),
                Container(
                    width: 50,
                    color: _voiceInputs![i].dataPage.dataOneResultCard != null
                        ? Colors.green
                        : Colors.red,
                    child: Padding(
                        padding: EdgeInsets.all(4),
                        child: ComponentTitle(
                            label:
                                _voiceInputs![i].dataPage.dataOneResultCard !=
                                        null
                                    ? "已答"
                                    : "未答",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontFamily: 'SourceSerif',
                              fontSize: 16.0,
                            ))))
              ],
            ),
          ));
      try {
        popupMenuItem![i] = item;
      } catch (e) {
        popupMenuItem!.add(item);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: gColorE1EBF5RGBA,
        shadowColor: Color.fromARGB(0, 0, 0, 0),
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
              child: PopupMenuButton<int>(
                tooltip: "打开题目菜单",
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),

                initialValue: _index, // 初始值
                itemBuilder: (context) {
                  // 子项构造函数
                  return popupMenuItem;
                },
                onSelected: (value) {
                  setState(() {
                    _index = value;
                    _process.value = _index.toDouble() / _listSize.toDouble();
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: ComponentRoundButton(
                func: _forward,
                child: Icon(
                  SOEIcons.left_arrow,
                  size: 18.0,
                  color: gColor749FC4,
                ),
                height: 32.0,
                width: 32.0,
                radius: 5.0,
                color: gColorCAE4F1RGBA,
              ),
            ),
            Text(
              widget._args.title,
              style: gTitleStyle,
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: ComponentRoundButton(
                func: _next,
                child: Icon(
                  SOEIcons.right_arrow,
                  color: gColor749FC4,
                  size: 18.0,
                ),
                height: 32.0,
                width: 32.0,
                radius: 5.0,
                color: gColorCAE4F1RGBA,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: ComponentRoundButton(
                func: _onExitClick,
                child: Icon(
                  SOEIcons.home,
                  color: gColor749FC4,
                  size: 18.0,
                ),
                height: 32.0,
                width: 32.0,
                radius: 5.0,
                color: gColorCAE4F1RGBA,
              ),
            ),
          ],
        ),
      ),
      body: _inputPage,
      bottomNavigationBar: _buildBottomWidget(),
    );
  }
}

class _ViewExamBody extends StatefulWidget {
  List<SubCpsrcds> _dataList;
  ArgsViewExam _args;
  _ViewExamBody(this._args, this._dataList);
  @override
  State<StatefulWidget> createState() => _ViewExamBodyState();
}

class ViewExam extends StatelessWidget {
  ViewExam({super.key});
  static const String routeName = 'exam';
  ArgsViewExam? _argsViewExam;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings;
    _argsViewExam = ModalRoute.of(context)!.settings.arguments as ArgsViewExam;
    return FutureBuilder<ExamResult>(
      future: MsgMgrQuestion().getExamByCpsgrpId(_argsViewExam!.cprsgrpId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _argsViewExam!.sumScore = snapshot.data!.totScore ?? 0.0;
          return _ViewExamBody(_argsViewExam!, snapshot.data!.listSubCpsrcd!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
