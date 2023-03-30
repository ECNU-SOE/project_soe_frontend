import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:record/record.dart' as rcd;
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart' as ffmpeg;

import 'package:project_soe/src/GGlobalParams/styles.dart';
import 'package:project_soe/src/VFullExam/DataQuestion.dart';

// 语音输入Component
class ComponentVoiceInput extends StatefulWidget with ChangeNotifier {
  // 文件数据, 包括录音地址.
  final DataQuestionPageMain dataPage;
  ComponentVoiceInput({super.key, required this.dataPage});
  @override
  State<ComponentVoiceInput> createState() => _ComponentVoiceInputState();
}

class _ComponentVoiceInputState extends State<ComponentVoiceInput> {
  _ComponentVoiceInputState({Key? key});
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
      widget.dataPage.dataEval.filePath != ''
          ? Icons.play_arrow
          : widget.dataPage.dataEval.isRecording
              ? Icons.stop
              : Icons.mic,
      color: Colors.amber,
      size: 32.0,
    );
  }

  Icon _retryIcon() {
    return Icon(
      Icons.restart_alt_sharp,
      color: (widget.dataPage.dataEval.filePath != '')
          ? Colors.amber
          : Colors.grey,
      size: 32.0,
    );
  }

  void _cbkRetry() {
    if (widget.dataPage.dataEval.isRecording ||
        widget.dataPage.dataEval.isUploading) {
      return;
    } else {
      _retryRecording();
    }
  }

  Future<void> _cbkRecordStopPlay() async {
    if (widget.dataPage.dataEval.isUploading) {
      return;
    }
    if (widget.dataPage.dataEval.filePath != '') {
      _playRecord();
    } else if (widget.dataPage.dataEval.isRecording) {
      _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (widget.dataPage.dataEval.isRecording ||
        widget.dataPage.dataEval.isUploading) {
      return;
    }
    if (await _audioRecorder.hasPermission()) {
      await _audioRecorder.start(
        encoder: rcd.AudioEncoder.aacLc,
        samplingRate: 16000,
      );
      if (await _audioRecorder.isRecording()) {
        setState(() {
          widget.dataPage.dataEval.isRecording = true;
        });
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!widget.dataPage.dataEval.isRecording) return;
    final recordRet = await _audioRecorder.stop();
    // HAX 22.11.19 避免录音未完成
    await Future.delayed(const Duration(milliseconds: 500));
    widget.dataPage.dataEval.filePath = recordRet!;
    setState(() {
      widget.dataPage.dataEval.isRecording = false;
      widget.dataPage.dataEval.isUploading = true;
    });
    await widget.dataPage.dataEval.postAndGetResultXf(
        widget.dataPage.toSingleString(),
        weight: widget.dataPage.weight);
    setState(() {
      widget.dataPage.dataEval.isUploading = false;
    });
  }

  void _retryRecording() {
    if (widget.dataPage.dataEval.filePath == '') return;
    if (widget.dataPage.dataEval.isRecording ||
        widget.dataPage.dataEval.isUploading) return;
    _audioPlayer.stop();
    setState(() {
      widget.dataPage.dataEval.filePath = '';
    });
  }

  void _playRecord() {
    if (widget.dataPage.dataEval.filePath == '') return;
    _audioPlayer.play(ap.DeviceFileSource(widget.dataPage.dataEval.filePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          '${widget.dataPage.title} 本题满分:${widget.dataPage.weight}',
          style: gFullExaminationSubTitleStyle,
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.dataPage.desc,
                style: gFullExaminationSubTitleStyle,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                widget.dataPage.toSingleString(),
                style: gFullExaminationTextStyle,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 55.0,
        color: Colors.white,
        child: widget.dataPage.dataEval.isUploading
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
                    (widget.dataPage.dataEval.filePath == '' ||
                            widget.dataPage.dataEval.resultXf == null)
                        ? '点击开始录音'
                        : '此题已有评测结果',
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
