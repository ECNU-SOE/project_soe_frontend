import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
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

class _ViewExamBodyState extends State<_ViewExamBody> {
  _ViewExamBodyState();
  int _index = 0;
  int _listSize = 0;
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
        if(voiceInput.dataPage.dataOneResultCard == null) {
          RegExp exp = RegExp(r"[\u4e00-\u9fa5]");
          int less = 0;
          List<DataOneWordCard> listDataOneWord = List.empty(growable: true);
          for(int i = 0; i < voiceInput.dataPage.refText!.length; ++ i) {
            if(exp.hasMatch(voiceInput.dataPage.refText![i])) {
              less ++;
              DataOneWordCard tmp = DataOneWordCard(isWrong: true, wrongShengDiao: false, wrongShengMu: false, wrongYunMu: false);
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
            tags: voiceInput.dataPage.tags 
          );
          voiceInput.dataPage.dataOneResultCard = tmp;
        } else cnt ++;
        lst.add(voiceInput.dataPage.dataOneResultCard!);
      }
      if(cnt == 0) {
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
              widget._args.sumScore
            )));
      }
    }
  }

  bool _checkAnyUploading() {
    if (_voiceInputs == null  || _voiceInputs!.isEmpty) {
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _inputPage = ComponentVoiceInput(dataPage: widget._dataList[_index], wrongsShow: false, add2Mis: true, subButShow: false);
    try {
      _voiceInputs![_index] = _inputPage!;
    } catch (e) {
      _voiceInputs!.add(_inputPage!);
    }
    _listSize = widget._dataList.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gColorE1EBF5RGBA,
        shadowColor: Color.fromARGB(0, 0, 0, 0),
        automaticallyImplyLeading: false,
        // bottom: ,
        toolbarHeight: 60.0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
      future:
          MsgMgrQuestion().getExamByCpsgrpId(_argsViewExam!.cprsgrpId),
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
