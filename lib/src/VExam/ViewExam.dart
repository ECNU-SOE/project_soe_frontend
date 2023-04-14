import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:project_soe/src/VAppHome/ViewAppHome.dart';
import 'package:project_soe/src/VExam/MsgQuestion.dart';
import 'package:project_soe/src/VExam/ViewExamResults.dart';
import 'package:project_soe/src/VNativeLanguageChoice/ViewNativeLanguageChoice.dart';
import 'package:project_soe/src/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/src/GGlobalParams/LabelText.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/VExam/DataQuestion.dart';

class _ViewExamBodyState extends State<_ViewExamBody> {
  _ViewExamBodyState();
  int _index = 0;
  int _listSize = 0;
  ComponentVoiceInput? _inputPage;
  List<ComponentVoiceInput>? _voiceInputs;
  final ValueNotifier<double> _process = ValueNotifier<double>(0.0);

  void _forward() {
    if (_index <= 0) {
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
                      style: gViewExamTextStyle,
                    ),
                    Text(
                      '(点击空白处关闭提示)',
                      style: gViewExamTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      List<DataQuestionPageMain> lst = List.empty(growable: true);
      for (final voiceInput in _voiceInputs!) {
        lst.add(voiceInput.dataPage);
      }
      Navigator.pushReplacementNamed(context, ViewExamResult.routeName,
          arguments: (ArgsViewExamResult(
            widget._args.cprsgrpId,
            lst,
            widget._args.endingRoute,
          )));
    }
  }

  bool _checkAnyUploading() {
    if (null == _voiceInputs) {
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
        height: 60.0,
        child: ElevatedButton(
          child: Text(
            "提   交",
            style: gViewExamSubTitleStyle,
          ),
          style: gViewExamSubButtonStyle,
          onPressed: onSubmitButtonPressed,
        ),
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
    _inputPage = ComponentVoiceInput(dataPage: widget._dataList[_index]);
    try {
      _voiceInputs![_index] = _inputPage!;
    } catch (e) {
      _voiceInputs!.add(_inputPage!);
    }
    _listSize = widget._dataList.length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _forward,
              child: Icon(Icons.arrow_left),
              style: gViewExamNavButtonStyle,
            ),
            Text(
              widget._args.title,
              style: gViewExamTitleStyle,
            ),
            ElevatedButton(
              onPressed: _next,
              child: Icon(Icons.arrow_right),
              style: gViewExamNavButtonStyle,
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
  List<DataQuestionPageMain> _dataList;
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
    _argsViewExam = ModalRoute.of(context)!.settings.arguments as ArgsViewExam;
    return FutureBuilder<List<DataQuestionPageMain>>(
      future:
          MsgMgrQuestion().getQuestionPageMainList(_argsViewExam!.cprsgrpId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _ViewExamBody(_argsViewExam!, snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
