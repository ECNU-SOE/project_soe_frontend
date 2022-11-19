import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:record/record.dart' as rcd;
import 'package:audioplayers/audioplayers.dart' as ap;

import 'package:project_soe/src/data/styles.dart';
import 'package:project_soe/src/data/exam_data.dart';

class VoiceInputPage extends StatefulWidget with ChangeNotifier {
  // 文件数据, 包括录音地址.
  final QuestionPageData questionPageData;
  bool _isRecording = false;
  bool _hasRecord = false;
  VoiceInputPage({super.key, required this.questionPageData});
  @override
  State<VoiceInputPage> createState() => _VoiceInputPageState();
}

class _VoiceInputPageState extends State<VoiceInputPage> {
  _VoiceInputPageState({Key? key});
  final _audioPlayer = ap.AudioPlayer();
  final _audioRecorder = rcd.Record();

  // 析构函数
  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _audioRecorder.stop();
    _audioRecorder.dispose();
    super.dispose();
  }

  Icon _recordIcon() {
    return Icon(
      widget._hasRecord
          ? Icons.play_arrow
          : widget._isRecording
              ? Icons.stop
              : Icons.mic,
      color: Colors.amber,
      size: 32.0,
    );
  }

  Icon _retryIcon() {
    return Icon(
      Icons.restart_alt_sharp,
      color: widget._hasRecord ? Colors.amber : Colors.grey,
      size: 32.0,
    );
  }

  void _cbkRetry() {
    if (widget._isRecording) {
      return;
    } else {
      _retryRecording();
    }
  }

  void _cbkRecordStopPlay() {
    if (widget._hasRecord) {
      _playRecord();
    } else if (widget._isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (widget._isRecording) return;
    try {
      if (!await _audioRecorder.hasPermission()) {
        return;
      }
      await _audioRecorder.start(
        // FIXME 注意, 格式可能和平台相异.
        encoder: rcd.AudioEncoder.wav,
        bitRate: 128000,
        samplingRate: 44100,
        numChannels: 2,
      );
      setState(() {
        widget._isRecording = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!widget._isRecording) return;
    final recordRet = await _audioRecorder.stop();
    // HAX 22.11.19 避免录音未完成
    await Future.delayed(const Duration(milliseconds: 100));
    if (recordRet != null) {
      widget.questionPageData.filePath = recordRet;
      await widget.questionPageData.postAndGetResult();
    } else {
      if (kDebugMode) print('Record returns a null path');
    }
    setState(() {
      widget._hasRecord = true;
      widget._isRecording = false;
    });
  }

  void _retryRecording() {
    if (!widget._hasRecord) return;
    if (widget._isRecording) return;
    _audioPlayer.stop();
    setState(() {
      widget._hasRecord = false;
      widget.questionPageData.filePath = '';
    });
  }

  void _playRecord() {
    if (!widget._hasRecord) return;
    _audioPlayer.play(ap.DeviceFileSource(widget.questionPageData.filePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          getQuestionTypeInfo(widget.questionPageData.type),
          style: gFullExaminationSubTitleStyle,
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, _) {
          return ListTile(
            title: Text(
              widget.questionPageData.toSingleString(),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: _recordIcon(),
              onPressed: _cbkRecordStopPlay,
            ),
            IconButton(
              icon: _retryIcon(),
              onPressed: _cbkRetry,
            ),
          ],
        ),
      ),
    );
  }
}
