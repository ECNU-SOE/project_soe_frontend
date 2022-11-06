import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:record/record.dart' as rcd;
import 'package:audioplayers/audioplayers.dart' as ap;

import '../data/styles.dart';

class VoiceInputComponent extends StatefulWidget with ChangeNotifier {
  // 录音文件的临时地址.
  String recordPath = '';
  VoiceInputComponent({super.key});
  @override
  State<VoiceInputComponent> createState() => _VoiceInputComponentState();
}

class _VoiceInputComponentState extends State<VoiceInputComponent> {
  bool _isRecording = false;
  bool _hasRecord = false;
  _VoiceInputComponentState({Key? key});
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

  Icon _submitIcon() {
    return const Icon(
      Icons.subscriptions,
      color: Colors.brown,
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

  void _cbkSubmit() {
    if (!_hasRecord) return;
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
    widget.notifyListeners();
  }

  void _retryRecording() {
    if (!_hasRecord) return;
    if (_isRecording) return;
    _audioPlayer.stop();
    setState(() {
      _hasRecord = false;
      widget.recordPath = '';
    });
    widget.notifyListeners();
  }

  void _playRecord() {
    if (!_hasRecord) return;
    _audioPlayer.play(ap.DeviceFileSource(widget.recordPath));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

// enum VoiceInputMode {
//   single,
//   word,
//   article,
//   sentance,
// }

class VoiceInputPage extends StatelessWidget {
  final List<String> wordList;
  // final VoiceInputMode inputMode;
  const VoiceInputPage({
    super.key,
    required this.wordList,
    // required this.inputMode,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        spacing: 12.0,
        runSpacing: 8.0,
        children: wordList
            .map((e) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(e, style: gVoiceInputWordStyle)))
            .toList(),
      ),
      bottomNavigationBar: VoiceInputComponent(),
    );
  }
}
