// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import 'package:audioplayers/audioplayers.dart' as ap;
// import 'package:record/record.dart' as rcd;

// import 'package:project_soe/src/GGlobalParams/styles.dart';
// import 'package:project_soe/src/VFullExam/DataQuestion.dart';

// // 跟读Component
// class ComponentVoiceFollow extends StatefulWidget with ChangeNotifier {
//   // 文件数据, 包括录音地址.
//   final DataQuestionPageFollow dataPage;
//   ComponentVoiceFollow({super.key, required this.dataPage});
//   @override
//   State<ComponentVoiceFollow> createState() => _ComponentVoiceFollowState();
// }

// class _ComponentVoiceFollowState extends State<ComponentVoiceFollow> {
//   _ComponentVoiceFollowState({Key? key});
//   final _audioPlayer = ap.AudioPlayer();
//   final _audioRecorder = rcd.Record();

//   // 析构函数
//   @override
//   void dispose() {
//     _audioPlayer.stop();
//     _audioPlayer.dispose();
//     _audioRecorder.stop();
//     _audioRecorder.dispose();
//     super.dispose();
//   }

//   Icon _recordIcon() {
//     return Icon(
//       widget.dataPage.filePath != ''
//           ? Icons.play_arrow
//           : widget.dataPage.isRecording
//               ? Icons.stop
//               : Icons.mic,
//       color: Colors.amber,
//       size: 32.0,
//     );
//   }

//   Icon _retryIcon() {
//     return Icon(
//       Icons.restart_alt_sharp,
//       color: (widget.dataPage.filePath != '') ? Colors.amber : Colors.grey,
//       size: 32.0,
//     );
//   }

//   void _cbkRetry() {
//     if (widget.dataPage.isRecording || widget.dataPage.isUploading) {
//       return;
//     } else {
//       _retryRecording();
//     }
//   }

//   Future<void> _cbkRecordStopPlay() async {
//     if (widget.dataPage.isUploading) {
//       return;
//     }
//     if (widget.dataPage.filePath != '') {
//       _playRecord();
//     } else if (widget.dataPage.isRecording) {
//       _stopRecording();
//     } else {
//       await _startRecording();
//     }
//   }

//   Future<void> _startRecording() async {
//     if (widget.dataPage.isRecording || widget.dataPage.isUploading) {
//       return;
//     }
//     if (await _audioRecorder.hasPermission()) {
//       await _audioRecorder.start(
//         encoder: rcd.AudioEncoder.aacLc,
//         samplingRate: 16000,
//       );
//       if (await _audioRecorder.isRecording()) {
//         setState(() {
//           widget.dataPage.isRecording = true;
//         });
//       }
//     }
//   }

//   Future<void> _stopRecording() async {
//     if (!widget.dataPage.isRecording) return;
//     final recordRet = await _audioRecorder.stop();
//     // HAX 22.11.19 避免录音未完成
//     await Future.delayed(const Duration(milliseconds: 500));
//     widget.dataPage.filePath = recordRet!;
//     setState(() {
//       widget.dataPage.isRecording = false;
//       widget.dataPage.isUploading = true;
//     });
//     await widget.dataPage.postAndGetResultXf();
//     setState(() {
//       widget.dataPage.isUploading = false;
//     });
//   }

//   void _retryRecording() {
//     if (widget.dataPage.filePath == '') return;
//     if (widget.dataPage.isRecording || widget.dataPage.isUploading) return;
//     _audioPlayer.stop();
//     setState(() {
//       widget.dataPage.filePath = '';
//     });
//   }

//   void _playRecord() {
//     if (widget.dataPage.filePath == '') return;
//     _audioPlayer.play(ap.DeviceFileSource(widget.dataPage.filePath));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: Text(
//           '${widget.dataPage.title} 本题满分:${widget.dataPage.weight}',
//           style: gFullExaminationSubTitleStyle,
//         ),
//       ),
//       body: ListView(
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Text(
//                 widget.dataPage.desc,
//                 style: gFullExaminationSubTitleStyle,
//               ),
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 12.0),
//               child: Text(
//                 widget.dataPage.toSingleString(),
//                 style: gFullExaminationTextStyle,
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 55.0,
//         color: Colors.white,
//         child: widget.dataPage.isUploading
//             ? Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     strokeWidth: 1.0,
//                     // semanticsLabel: '',
//                   ),
//                   Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(15.0),
//                       child: (Text(
//                         '评测进行中, 请稍等...',
//                         style: gFullExaminationSubTitleStyle,
//                       )),
//                     ),
//                   ),
//                 ],
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     (widget.dataPage.filePath == '' ||
//                             widget.dataPage.resultDataXf == null)
//                         ? '点击开始录音'
//                         : '此题已有评测结果',
//                     style: gFullExaminationSubTitleStyle,
//                   ),
//                   IconButton(
//                     icon: _recordIcon(),
//                     onPressed: _cbkRecordStopPlay,
//                   ),
//                   IconButton(
//                     icon: _retryIcon(),
//                     onPressed: _cbkRetry,
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
