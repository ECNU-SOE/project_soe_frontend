import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:record/record.dart' as rcd;
import 'package:audioplayers/audioplayers.dart' as ap;

import 'package:project_soe/src/data/styles.dart';
import 'package:project_soe/src/data/exam_data.dart';

class VoiceInputPage extends StatefulWidget with ChangeNotifier {
  // 录音文件的临时地址.
  String recordPath = '';
  final List<QuestionData> wordList;
  bool _isRecording = false;
  bool _hasRecord = false;
  VoiceInputPage({super.key, required this.wordList});
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

  Icon _submitIcon() {
    return const Icon(
      Icons.check,
      color: Colors.brown,
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

  void _cbkSubmit() {
    if (!widget._hasRecord) return;
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
    if (recordRet != null) {
      widget.recordPath = recordRet;
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
      widget.recordPath = '';
    });
  }

  void _playRecord() {
    if (!widget._hasRecord) return;
    _audioPlayer.play(ap.DeviceFileSource(widget.recordPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        spacing: 12.0,
        runSpacing: 8.0,
        children: widget.wordList
            .map((e) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(e.label, style: gVoiceInputWordStyle)))
            .toList(),
      ),
      bottomNavigationBar: Row(
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
          IconButton(
            icon: _submitIcon(),
            onPressed: _cbkSubmit,
          ),
        ],
      ),
    );
  }
}
