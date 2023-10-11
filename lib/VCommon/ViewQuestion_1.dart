// import 'dart:async';
// import 'dart:convert';
// import 'dart:ffi';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import 'package:audioplayers/audioplayers.dart' as ap;
// import 'package:http/http.dart' as http;
// import 'package:project_soe/VCommon/DataAllResultsCard.dart';
// import 'package:project_soe/VMistakeBook/ViewMistakeCard.dart';
// import 'package:project_soe/VMistakeBook/ViewMistakeDetail.dart';
// import 'package:quiver/strings.dart';
// import 'package:record/record.dart' as rcd;
// import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart' as ffmpeg;

// import 'package:project_soe/s_o_e_icons_icons.dart';
// import 'package:project_soe/GGlobalParams/Styles.dart';
// import 'package:project_soe/VExam/DataQuestion.dart';
// import 'package:project_soe/CComponents/ComponentShadowedContainer.dart';
// import 'package:project_soe/CComponents/ComponentSubtitle.dart';
// import 'package:project_soe/CComponents/ComponentRoundButton.dart';

// // Map<int, String> mp = {-1: '无', 0: '无', 1: '字', 2: '词', 3: '句子', 4: '段落'};

// // 语音输入Component
// class ViewQuestion_1 extends StatefulWidget with ChangeNotifier {
//   // 文件数据, 包括录音地址.
//   final DataQuestionPageMain dataPage;
//   final bool titleShow;
//   bool wrongsShow;
//   ViewQuestion_1(
//       {super.key,
//       required this.dataPage,
//       required this.titleShow,
//       this.wrongsShow = false});
//   @override
//   State<ViewQuestion_1> createState() => _ViewQuestion_1State();
// }

// class _ViewQuestion_1State extends State<ViewQuestion_1> {
//   _ViewQuestion_1State({Key? key});
//   final _audioPlayer = ap.AudioPlayer();
//   final _audioRecorder = rcd.Record();

//   @override
//   void initState() {
//     super.initState();
//   }

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
//       // widget.dataPage.hasRecordFile()
//       // ? Icons.play_arrow
//       // :
//       widget.dataPage.isRecording() ? SOEIcons.pause : SOEIcons.mic,
//       color: widget.dataPage.hasRecordFile() ? Colors.grey : gColor749FC4,
//       size: 32.0,
//     );
//   }

//   Icon _retryIcon() {
//     return Icon(
//       Icons.restart_alt_sharp,
//       color: (widget.dataPage.hasRecordFile()) ? gColor749FC4 : Colors.grey,
//       size: 17.0,
//     );
//   }

//   void _cbkRetry() {
//     if (widget.dataPage.isRecording() || widget.dataPage.isUploading()) {
//       return;
//     } else {
//       _retryRecording();
//     }
//   }

//   Future<void> _cbkRecordStop() async {
//     if (widget.dataPage.isUploading() || widget.dataPage.hasRecordFile()) {
//       return;
//     }
//     // if (widget.dataPage.hasRecordFile()) {
//     // _playRecord();
//     // }
//     else if (widget.dataPage.isRecording()) {
//       _stopRecording();
//     } else {
//       await _startRecording();
//     }
//   }

//   Future<void> _startRecording() async {
//     if (widget.dataPage.isRecording() || widget.dataPage.isUploading()) {
//       return;
//     }
//     if (await _audioRecorder.hasPermission()) {
//       _stopExampleAudio();
//       await _audioRecorder.start(
//         encoder: rcd.AudioEncoder.aacLc,
//         samplingRate: 16000,
//       );
//       if (await _audioRecorder.isRecording()) {
//         setState(() {
//           widget.dataPage.setRecording(true);
//           widget.dataPage.setPlayingExample(false);
//           widget.dataPage.setStartPlaying(false);
//         });
//       }
//     }
//   }

//   Future<void> _stopRecording() async {
//     if (!widget.dataPage.isRecording()) return;
//     final recordRet = await _audioRecorder.stop();
//     widget.dataPage.setFilePath(recordRet!);
//     setState(() {
//       widget.dataPage.setRecording(false);
//       widget.dataPage.setUploading(true);
//     });
//     // ---------------- test !!!
//     await widget.dataPage.postAndGetResultXf(
//         widget.dataPage.id != null && widget.dataPage.id != ''
//             ? widget.dataPage.id
//             : "");

//     setState(() {
//       widget.dataPage.setUploading(false);
//     });
//   }

//   void _retryRecording() {
//     if (!widget.dataPage.hasRecordFile()) return;
//     if (widget.dataPage.isRecording() || widget.dataPage.isUploading()) return;
//     // _audioPlayer.stop();
//     setState(() {
//       widget.dataPage.setFilePath('');
//     });
//   }

//   // void _playRecord() {
//   //   if (!widget.dataPage.hasRecordFile()) return;
//   //   _audioPlayer.play(ap.DeviceFileSource(widget.dataPage.getFilePath()));
//   // }

//   void _resumeExampleAudio() {
//     _audioPlayer.resume();
//   }

//   void _pauseExampleAudio() {
//     _audioPlayer.pause();
//   }

//   void _playExampleAudio() {
//     _audioPlayer.play(ap.UrlSource(widget.dataPage.audioUri));
//   }

//   void _stopExampleAudio() {
//     _audioPlayer.stop();
//   }

//   void _cbkExampleStop() {
//     if (!widget.dataPage.isStartPlaying()) {
//       return;
//     }
//     _stopExampleAudio();
//     setState(() {
//       widget.dataPage.setStartPlaying(false);
//       widget.dataPage.setPlayingExample(false);
//     });
//   }

//   void _cbkExamplePlayPause() {
//     if (widget.dataPage.isRecording()) return;
//     bool isPlaying = widget.dataPage.isPlayingExample();
//     if (isPlaying) {
//       _pauseExampleAudio();
//     } else {
//       if (widget.dataPage.isStartPlaying()) {
//         _resumeExampleAudio();
//       } else {
//         _playExampleAudio();
//         widget.dataPage.setStartPlaying(true);
//       }
//     }
//     setState(() {
//       widget.dataPage.setPlayingExample(!isPlaying);
//     });
//   }

//   Icon _playPauseExampleIcon() {
//     return Icon(
//       (widget.dataPage.isPlayingExample()
//           ? SOEIcons.pause
//           : SOEIcons.right_vector),
//       color: gColor749FC4,
//       size: 16.0,
//     );
//   }

//   Icon _stopExmapleIcon() {
//     return Icon(
//       Icons.restart_alt_sharp,
//       color: widget.dataPage.isStartPlaying() ? gColor749FC4 : Colors.grey,
//       size: 16.0,
//     );
//   }

//   Widget _buildExampleAudioPlayer(BuildContext context) {
//     // print(widget.dataPage.audioUri);
//     if (widget.dataPage.audioUri.isEmpty || widget.dataPage.audioUri == '') {
//       return ComponentSubtitle(
//         label: '没有示例语音',
//         style: gSubtitleStyle,
//       );
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ComponentSubtitle(
//           label: '示例语音',
//           style: gSubtitleStyle,
//         ),
//         Padding(
//           padding: EdgeInsets.all(3.0),
//           child: ComponentCircleButton(
//             func: _cbkExamplePlayPause,
//             color: gColorCAE4F1RGBA,
//             child: _playPauseExampleIcon(),
//             size: 32,
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.all(3.0),
//           child: ComponentCircleButton(
//             func: _cbkExampleStop,
//             color: gColorCAE4F1RGBA,
//             child: _stopExmapleIcon(),
//             size: 32,
//           ),
//         ),
//       ],
//     );
//   }

//   List<String> wrongSheng = [];

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     List<Widget> children = List.empty(growable: true);
//     print(widget.dataPage.dataQuestion.label);
//     children.addAll([
//         widget.titleShow
//             ? Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 12.0, top: 10.0),
//                   child: Text(
//                     widget.dataPage.desc,
//                     style: gSubtitleStyle,
//                   ),
//                 ),
//               )
//             : Container(),
//         Container(
//           padding: EdgeInsets.only(left: 15, bottom: 10),
//           child: Text(
//             widget.dataPage.getScoreDescString(!widget.titleShow),
//             style: gInfoTextStyle,
//           ),
//         ),
//         widget.dataPage.getRichText4Show(
//                 widget.dataPage.pinyin,
//                 widget.dataPage.dataQuestion.label,
//                 screenSize.width,
//                 wrongSheng,
//                 widget.wrongsShow),    
//       ],
//     );
//     List<Widget> tags = List.empty(growable: true);
//     tags.addAll([
//       ComponentSubtitle(
//         label: '${widget.dataPage.title}',
//         style: gTitleStyle,
//       ),
//       ComponentSubtitle(
//         label: '标签：',
//         style: gSubtitleStyle,
//       ),
//     ]);
//     if (widget.dataPage.dataQuestion.tags.isEmpty) {
//       tags.add(ComponentSubtitle(
//         label: '无',
//         style: gSubtitleStyle,
//       ));
//     } else {
//       for (var tag in widget.dataPage.dataQuestion.tags) {
//         tags.add(ComponentSubtitle(
//           label: tag,
//           style: gSubtitleStyle,
//         ));
//       }
//     }
    
//     return Scaffold(
//       backgroundColor: gColorE1EBF5RGBA,
//       appBar: AppBar(
//         shadowColor: Color.fromARGB(0, 0, 0, 0),
//         automaticallyImplyLeading: false,
//         backgroundColor: gColorE1EBF5RGBA,
//         toolbarHeight: 80.0,
//         title: Column(
//           children: [
//             Row(
//               children: tags,
//             ),
//             _buildExampleAudioPlayer(context),
//           ],
//         ),
//       ),
//       body: SizedBox(
//         width: screenSize.width,
//         child: ComponentShadowedContainer(
//           color: gColorFFFFFFRGBA,
//           shadowColor: gColorE1EBF5RGBA,
//           edgesHorizon: 26.5,
//           edgesVertical: 10,
//           child: ListView(
//             children: children,
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         height: 60.0,
//         color: gColorE1EBF5RGBA,
//         child: widget.dataPage.isUploading()
//             ? Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     strokeWidth: 4.0,
//                     // semanticsLabel: '',
//                   ),
//                   Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(15.0),
//                       child: (Text(
//                         '评测进行中, 请稍等...',
//                         style: gSubtitleStyle,
//                       )),
//                     ),
//                   ),
//                 ],
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         (!widget.dataPage.hasRecordFile() ||
//                                 widget.dataPage.resultXf == null)
//                             ? (widget.dataPage.isRecording()
//                                 ? '正在录音'
//                                 : '点击开始录音')
//                             : '此题已有评测结果',
//                         style: gSubtitleStyle,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 6.0),
//                         child: ComponentCircleButton(
//                           func: _cbkRecordStop,
//                           child: _recordIcon(),
//                           size: 56,
//                           color: gColorE3EDF7RGBA,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 0.0),
//                     child: ComponentCircleButton(
//                       func: _cbkRetry,
//                       child: _retryIcon(),
//                       size: 32,
//                       color: gColorE3EDF7RGBA,
//                     ),
//                   ),
//                   widget.titleShow
//                       ? Container()
//                       : Padding(
//                           padding: EdgeInsets.only(left: 0),
//                           child: TextButton(
//                             child: Text('提交'),
//                             onPressed: (() {
//                               // ........
//                               setState(() {
//                                 if (widget.dataPage.resultXf != null) {
//                                   wrongSheng.clear();
//                                   for (var x
//                                       in widget.dataPage.resultXf!.wrongSheng) {
//                                     var tmp = x.toJson();
//                                     print(tmp[9]);
//                                     print('----------------');
//                                     wrongSheng.add(tmp[9]);
//                                   }
//                                   widget.dataPage.setStartPlaying(false);
//                                   widget.dataPage.setRecording(false);
//                                   widget.dataPage.setFilePath('');
//                                   widget.dataPage.setUploading(false);
//                                   widget.dataPage.resultXf = null;
//                                 }
//                                 widget.wrongsShow = true;
//                               });
//                             }),
//                           ),
//                         )
//                   // color: gColorE3EDF7RGBA,
//                 ],
//               ),
//       ),
//     );
//   }
// }
