import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:record/record.dart' as rcd;
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart' as ffmpeg;

import 'package:project_soe/src/GGlobalParams/styles.dart';
import 'package:project_soe/src/VFullExam/DataExam.dart';

class ComponentVoiceInput extends StatefulWidget with ChangeNotifier {
  // 文件数据, 包括录音地址.
  final DataQuestionPage questionPageData;
  ComponentVoiceInput({super.key, required this.questionPageData});
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
      widget.questionPageData.filePath != ''
          ? Icons.play_arrow
          : widget.questionPageData.isRecording
              ? Icons.stop
              : Icons.mic,
      color: Colors.amber,
      size: 32.0,
    );
  }

  Icon _retryIcon() {
    return Icon(
      Icons.restart_alt_sharp,
      color:
          (widget.questionPageData.filePath != '') ? Colors.amber : Colors.grey,
      size: 32.0,
    );
  }

  void _cbkRetry() {
    if (widget.questionPageData.isRecording ||
        widget.questionPageData.isUploading) {
      return;
    } else {
      _retryRecording();
    }
  }

  Future<void> _cbkRecordStopPlay() async {
    if (widget.questionPageData.isUploading) {
      return;
    }
    if (widget.questionPageData.filePath != '') {
      _playRecord();
    } else if (widget.questionPageData.isRecording) {
      _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (widget.questionPageData.isRecording ||
        widget.questionPageData.isUploading) {
      return;
    }
    if (await _audioRecorder.hasPermission()) {
      await _audioRecorder.start(
        encoder: rcd.AudioEncoder.aacLc,
        samplingRate: 16000,
      );
      if (await _audioRecorder.isRecording()) {
        setState(() {
          widget.questionPageData.isRecording = true;
        });
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!widget.questionPageData.isRecording) return;
    final recordRet = await _audioRecorder.stop();
    // HAX 22.11.19 避免录音未完成
    await Future.delayed(const Duration(milliseconds: 500));
    widget.questionPageData.filePath = recordRet!;
    setState(() {
      widget.questionPageData.isRecording = false;
      widget.questionPageData.isUploading = true;
    });
    await widget.questionPageData.postAndGetResultXf();
    setState(() {
      widget.questionPageData.isUploading = false;
    });
  }

  void _retryRecording() {
    if (widget.questionPageData.filePath == '') return;
    if (widget.questionPageData.isRecording ||
        widget.questionPageData.isUploading) return;
    _audioPlayer.stop();
    setState(() {
      widget.questionPageData.filePath = '';
    });
  }

  void _playRecord() {
    if (widget.questionPageData.filePath == '') return;
    _audioPlayer.play(ap.DeviceFileSource(widget.questionPageData.filePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          '${widget.questionPageData.title} 本题满分:${widget.questionPageData.weight}',
          style: gFullExaminationSubTitleStyle,
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.questionPageData.desc,
                style: gFullExaminationSubTitleStyle,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                widget.questionPageData.toSingleString(),
                style: gFullExaminationTextStyle,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 55.0,
        color: Colors.white,
        child: widget.questionPageData.isUploading
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
                            widget.questionPageData.resultDataXf == null)
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
