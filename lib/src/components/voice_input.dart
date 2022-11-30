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
  bool isRecording = false;
  bool isUploading = false;
  bool _hasRecord = false;
  VoiceInputPage({super.key, required this.questionPageData}) {
    _hasRecord = questionPageData.filePath != '';
  }
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
          : widget.isRecording
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
    if (widget.isRecording) {
      return;
    } else {
      _retryRecording();
    }
  }

  void _cbkRecordStopPlay() {
    if (widget._hasRecord) {
      _playRecord();
    } else if (widget.isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (widget.isRecording) return;
    try {
      if (!await _audioRecorder.hasPermission()) {
        return;
      }
      await _audioRecorder.start(
        // FIXME 注意, 格式可能和平台相异.
        encoder: rcd.AudioEncoder.wav,
        numChannels: 1,
        samplingRate: 16000,
      );
      setState(() {
        widget.isRecording = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!widget.isRecording) return;
    final recordRet = await _audioRecorder.stop();
    if (recordRet != null) {
      widget.questionPageData.filePath = recordRet;
      setState(() {
        widget.isUploading = true;
      });
      // HAX 22.11.19 避免录音未完成
      await Future.delayed(const Duration(milliseconds: 100));
      await widget.questionPageData.postAndGetResult();
      setState(() {
        widget.isUploading = false;
        widget._hasRecord = true;
        widget.isRecording = false;
      });
    } else {
      if (kDebugMode) print('Record returns a null path');
    }
  }

  void _retryRecording() {
    if (!widget._hasRecord) return;
    if (widget.isRecording) return;
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
        height: 55.0,
        color: Colors.white,
        child: widget.isUploading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 1.0,
                    // semanticsLabel: '',
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: (Text(
                        '评测进行中, 请稍等...',
                        style: gFullExaminationSubTitleStyle,
                      )),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    (widget.questionPageData.filePath == '' ||
                            widget.questionPageData.resultData == null)
                        ? '点击开始录音'
                        : '您的分数是${widget.questionPageData.resultData!.suggestedScore}',
                    style: gFullExaminationSubTitleStyle,
                  ),
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
