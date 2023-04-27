import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:quiver/strings.dart';
import 'package:record/record.dart' as rcd;
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart' as ffmpeg;

import 'package:project_soe/src/s_o_e_icons_icons.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/VExam/DataQuestion.dart';
import 'package:project_soe/src/CComponents/ComponentShadowedContainer.dart';
import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/src/CComponents/ComponentRoundButton.dart';

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
      widget.dataPage.isRecording() ? SOEIcons.pause : SOEIcons.mic,
      color: widget.dataPage.hasRecordFile() ? Colors.grey : gColor749FC4,
      size: 32.0,
    );
  }

  Icon _retryIcon() {
    return Icon(
      Icons.restart_alt_sharp,
      color: (widget.dataPage.hasRecordFile()) ? gColor749FC4 : Colors.grey,
      size: 17.0,
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
      (widget.dataPage.isPlayingExample()
          ? SOEIcons.pause
          : SOEIcons.right_vector),
      color: gColor749FC4,
      size: 16.0,
    );
  }

  Icon _stopExmapleIcon() {
    return Icon(
      Icons.restart_alt_sharp,
      color: widget.dataPage.isStartPlaying() ? gColor749FC4 : Colors.grey,
      size: 16.0,
    );
  }

  Widget _buildExampleAudioPlayer(BuildContext context) {
    if (widget.dataPage.audioUri.isEmpty || widget.dataPage.audioUri == '') {
      return ComponentSubtitle(
        label: '没有示例语音',
        style: gSubtitleStyle,
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ComponentSubtitle(
          label: '示例语音',
          style: gSubtitleStyle,
        ),
        Padding(
          padding: EdgeInsets.all(3.0),
          child: ComponentCircleButton(
            func: _cbkExamplePlayPause,
            color: gColorCAE4F1RGBA,
            child: _playPauseExampleIcon(),
            size: 32,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(3.0),
          child: ComponentCircleButton(
            func: _cbkExampleStop,
            color: gColorCAE4F1RGBA,
            child: _stopExmapleIcon(),
            size: 32,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List.empty(growable: true);
    children.addAll(
      [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0, top: 10.0),
            child: Text(
              widget.dataPage.desc,
              style: gSubtitleStyle,
            ),
          ),
        ),
        Center(
          child: Text(
            widget.dataPage.getScoreDescString(),
            style: gInfoTextStyle,
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              widget.dataPage.toSingleString(),
              style: gInfoTextStyle,
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: gColorE1EBF5RGBA,
      appBar: AppBar(
        shadowColor: Color.fromARGB(0, 0, 0, 0),
        automaticallyImplyLeading: false,
        backgroundColor: gColorE1EBF5RGBA,
        toolbarHeight: 80.0,
        title: Column(
          children: [
            ComponentSubtitle(
              label: '${widget.dataPage.title}',
              style: gTitleStyle,
            ),
            _buildExampleAudioPlayer(context),
          ],
        ),
      ),
      body: Center(
        child: ComponentShadowedContainer(
          color: gColorFFFFFFRGBA,
          shadowColor: gColorE1EBF5RGBA,
          edgesHorizon: 26.5,
          edgesVertical: 50,
          child: ListView(
            children: children,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60.0,
        color: gColorE1EBF5RGBA,
        child: widget.dataPage.isUploading()
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 4.0,
                    // semanticsLabel: '',
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: (Text(
                        '评测进行中, 请稍等...',
                        style: gSubtitleStyle,
                      )),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        (!widget.dataPage.hasRecordFile() ||
                                widget.dataPage.resultXf == null)
                            ? (widget.dataPage.isRecording()
                                ? '正在录音'
                                : '点击开始录音')
                            : '此题已有评测结果',
                        style: gSubtitleStyle,
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: ComponentCircleButton(
                          func: _cbkRecordStop,
                          child: _recordIcon(),
                          size: 56,
                          color: gColorE3EDF7RGBA,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: ComponentCircleButton(
                      func: _cbkRetry,
                      child: _retryIcon(),
                      size: 32,
                      color: gColorE3EDF7RGBA,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
