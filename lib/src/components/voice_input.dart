import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:record/record.dart' as rcd;
import 'package:audioplayers/audioplayers.dart' as ap;

class VoiceInputComponent extends StatefulWidget with ChangeNotifier {
  final String label;
  // 录音文件的临时地址.
  String recordPath = '';
  VoiceInputComponent({Key? key, required this.label}) : super(key: key);
  @override
  State<VoiceInputComponent> createState() =>
      _VoiceInputComponentState(label: label);
}

class _VoiceInputComponentState extends State<VoiceInputComponent>
    with ChangeNotifier {
  bool _isRecording = false;
  bool _hasRecord = false;
  final String label;
  _VoiceInputComponentState({Key? key, required this.label});
  final _audioPlayer = ap.AudioPlayer();
  final _audioRecorder = rcd.Record();

  @override
  void initState() {
    super.initState();
  }

  // 析构函数
  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  final TextStyle _testStyle = const TextStyle(
    color: Colors.black87,
    fontSize: 32.0,
  );

  Icon _recordIcon() {
    return Icon(
      _hasRecord
          ? Icons.play_arrow
          : _isRecording
              ? Icons.stop
              : Icons.mic,
      color: Colors.amber,
      size: 32.0,
    );
  }

  Icon _retryIcon() {
    return Icon(
      Icons.restart_alt_sharp,
      color: _hasRecord ? Colors.amber : Colors.grey,
      size: 32.0,
    );
  }

  void _cbkRetry() {
    if (_isRecording) {
      return;
    } else {
      _retryRecording();
    }
  }

  void _cbkRecordStopPlay() {
    if (_hasRecord) {
      _playRecord();
    } else if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;
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
        _isRecording = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    final recordRet = await _audioRecorder.stop();
    if (recordRet != null) {
      widget.recordPath = recordRet;
    } else {
      if (kDebugMode) print('Record returns a null path');
    }
    setState(() {
      _hasRecord = true;
      _isRecording = false;
    });
    notifyListeners();
  }

  void _retryRecording() {
    if (!_hasRecord) return;
    if (_isRecording) return;
    _audioPlayer.stop();
    setState(() {
      _hasRecord = false;
    });
    notifyListeners();
  }

  void _playRecord() {
    if (!_hasRecord) return;
    _audioPlayer.play(ap.DeviceFileSource(widget.recordPath));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            label,
            style: _testStyle,
            softWrap: true,
          ),
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
    );
  }
}
