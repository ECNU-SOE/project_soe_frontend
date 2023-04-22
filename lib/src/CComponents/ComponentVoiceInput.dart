import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';
import 'package:quiver/strings.dart';
import 'package:record/record.dart' as rcd;
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart' as ffmpeg;

import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/VExam/DataQuestion.dart';

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
      // widget.dataPage.hasRecordFile()
      // ? Icons.play_arrow
      // :
      widget.dataPage.isRecording() ? Icons.stop : Icons.mic,
      color: widget.dataPage.hasRecordFile() ? Colors.grey : Colors.amber,
      size: 32.0,
    );
  }

  Icon _retryIcon() {
    return Icon(
      Icons.restart_alt_sharp,
      color: (widget.dataPage.hasRecordFile()) ? Colors.amber : Colors.grey,
      size: 32.0,
    );
  }

  void _cbkRetry() {
    if (widget.dataPage.isRecording() || widget.dataPage.isUploading()) {
      return;
    } else {
      _retryRecording();
    }
  }

  Future<void> _cbkRecordStop() async {
    if (widget.dataPage.isUploading() || widget.dataPage.hasRecordFile()) {
      return;
    }
    // if (widget.dataPage.hasRecordFile()) {
    // _playRecord();
    // }
    else if (widget.dataPage.isRecording()) {
      _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (widget.dataPage.isRecording() || widget.dataPage.isUploading()) {
      return;
    }
    if (await _audioRecorder.hasPermission()) {
      _stopExampleAudio();
      await _audioRecorder.start(
        encoder: rcd.AudioEncoder.aacLc,
        samplingRate: 16000,
      );
      if (await _audioRecorder.isRecording()) {
        setState(() {
          widget.dataPage.setRecording(true);
          widget.dataPage.setPlayingExample(false);
          widget.dataPage.setStartPlaying(false);
        });
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!widget.dataPage.isRecording()) return;
    final recordRet = await _audioRecorder.stop();
    widget.dataPage.setFilePath(recordRet!);
    setState(() {
      widget.dataPage.setRecording(false);
      widget.dataPage.setUploading(true);
    });
    await widget.dataPage.postAndGetResultXf();
    setState(() {
      widget.dataPage.setUploading(false);
    });
  }

  void _retryRecording() {
    if (!widget.dataPage.hasRecordFile()) return;
    if (widget.dataPage.isRecording() || widget.dataPage.isUploading()) return;
    // _audioPlayer.stop();
    setState(() {
      widget.dataPage.setFilePath('');
    });
  }

  // void _playRecord() {
  //   if (!widget.dataPage.hasRecordFile()) return;
  //   _audioPlayer.play(ap.DeviceFileSource(widget.dataPage.getFilePath()));
  // }

  void _resumeExampleAudio() {
    _audioPlayer.resume();
  }

  void _pauseExampleAudio() {
    _audioPlayer.pause();
  }

  void _playExampleAudio() {
    _audioPlayer.play(ap.UrlSource(widget.dataPage.audioUri));
  }

  void _stopExampleAudio() {
    _audioPlayer.stop();
  }

  void _cbkExampleStop() {
    if (!widget.dataPage.isStartPlaying()) {
      return;
    }
    _stopExampleAudio();
    setState(() {
      widget.dataPage.setStartPlaying(false);
      widget.dataPage.setPlayingExample(false);
    });
  }

  void _cbkExamplePlayPause() {
    if (widget.dataPage.isRecording()) return;
    bool isPlaying = widget.dataPage.isPlayingExample();
    if (isPlaying) {
      _pauseExampleAudio();
    } else {
      if (widget.dataPage.isStartPlaying()) {
        _resumeExampleAudio();
      } else {
        _playExampleAudio();
        widget.dataPage.setStartPlaying(true);
      }
    }
    setState(() {
      widget.dataPage.setPlayingExample(!isPlaying);
    });
  }

  Icon _playPauseExampleIcon() {
    return Icon(
      (widget.dataPage.isPlayingExample() ? Icons.pause : Icons.play_arrow),
      color: Colors.amber,
      size: 32.0,
    );
  }

  Icon _stopExmapleIcon() {
    return Icon(
      Icons.restart_alt_sharp,
      color: widget.dataPage.isStartPlaying() ? Colors.amber : Colors.grey,
      size: 32.0,
    );
  }

  List<Widget> _buildExampleAudioPlayer(BuildContext context) {
    if (widget.dataPage.audioUri.isEmpty || widget.dataPage.audioUri == '') {
      return [Subtitle(label: '没有示例语音')];
    }
    return [
      Row(
        children: [
          Subtitle(label: '示例语音'),
          IconButton(
              onPressed: _cbkExamplePlayPause, icon: _playPauseExampleIcon()),
          IconButton(onPressed: _cbkExampleStop, icon: _stopExmapleIcon()),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List.empty(growable: true);
    children.addAll(_buildExampleAudioPlayer(context));
    children.addAll([
      Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            widget.dataPage.desc,
            style: gViewExamSubTitleStyle,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            widget.dataPage.toSingleString(),
            style: gViewExamTextStyle,
          ),
        ),
      ),
    ]);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          '${widget.dataPage.title}',
          style: gViewExamSubTitleStyle,
        ),
      ),
      body: ListView(children: children),
      bottomNavigationBar: Container(
        height: 55.0,
        color: Colors.white,
        child: widget.dataPage.isUploading()
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
                        style: gViewExamSubTitleStyle,
                      )),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                      onPressed: _cbkRecordStop,
                      child: Row(
                        children: [
                          Text(
                            (!widget.dataPage.hasRecordFile() ||
                                    widget.dataPage.resultXf == null)
                                ? '点击开始录音'
                                : '此题已有评测结果',
                            style: gViewExamSubTitleStyle,
                          ),
                          _recordIcon(),
                        ],
                      )),
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
