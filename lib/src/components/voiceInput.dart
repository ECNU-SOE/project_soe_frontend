import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class VoiceInputComponent extends StatefulWidget {
  final String label;
  const VoiceInputComponent({Key? key, required this.label}) : super(key: key);
  @override
  State<VoiceInputComponent> createState() =>
      VoiceInputComponentState(label: label);
}

class VoiceInputComponentState extends State<VoiceInputComponent> {
  bool _isRecording = false;
  bool _hasRecord = false;
  final String label;
  VoiceInputComponentState({Key? key, required this.label});

  @override
  void initState() {
    super.initState();
  }

  final TextStyle _testStyle = const TextStyle(
    color: Colors.white,
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
      size: 48.0,
    );
  }

  Icon _retryIcon() {
    return Icon(
      Icons.restart_alt_sharp,
      color: _hasRecord ? Colors.amber : Colors.grey,
      size: 48.0,
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

  void _startRecording() {
    if (_isRecording) return;
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() {
    if (!_isRecording) return;
    setState(() {
      _hasRecord = true;
      _isRecording = false;
    });
  }

  void _retryRecording() {
    if (!_hasRecord) return;
    if (_isRecording) return;
    setState(() {
      _hasRecord = false;
    });
  }

  void _playRecord() {
    if (!_hasRecord) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.baseline,
        children: <Widget>[
          Text(
            label,
            style: _testStyle,
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
    );
  }
}
