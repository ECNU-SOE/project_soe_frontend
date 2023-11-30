import 'dart:async';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:project_soe/VMistakeBook/ViewMistakeCard.dart';
import 'package:project_soe/VMistakeBook/ViewMistakeDetail.dart';
import 'package:quiver/strings.dart';
import 'package:record/record.dart' as rcd;
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart' as ffmpeg;
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'package:project_soe/s_o_e_icons_icons.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/CComponents/ComponentShadowedContainer.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';

// 语音输入Component
class ComponentVoiceInput extends StatefulWidget with ChangeNotifier {
  // 文件数据, 包括录音地址.
  final SubCpsrcds dataPage;
  bool add2Mis;
  bool wrongsShow;
  bool subButShow;
  bool recordShow;
  int questionNum;
  int nowIdx;
  String typeIdx;
  String typeScore;
  String description;
  bool valueIdx = false;
  // bool nextBut;
  // int idx;
  // bool goNext;
  ComponentVoiceInput(
      {super.key,
      required this.dataPage,
      this.wrongsShow = false,
      this.add2Mis = false,
      this.subButShow = false,
      this.recordShow = true,
      this.questionNum = -1,
      this.nowIdx = -1,
      this.typeIdx = "",
      this.typeScore = "",
      this.description = ""
      // this.nextBut = false,
      // this.idx = 0,
      // this.goNext = false
      });
  @override
  State<ComponentVoiceInput> createState() => _ComponentVoiceInputState();
}

class _ComponentVoiceInputState extends State<ComponentVoiceInput> {
  _ComponentVoiceInputState({Key? key});
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
    _audioRecorder.stop();
    _audioRecorder.dispose();
    super.dispose();
  }

  Icon _recordIcon() {
    return Icon(
      widget.dataPage.hasRecordFile()
          ? Icons.play_arrow
          : widget.dataPage.isRecording()
              ? SOEIcons.pause
              : SOEIcons.mic,
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

  Future<void> _cbkRecordStop(bool subButShow) async {
    if (widget.dataPage.isUploading()) {
      return;
    }

    if (widget.dataPage.hasRecordFile()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              child: Text(
                "确定",
                style: gInfoTextStyle,
              ),
              onPressed: () {
                _retryRecording();

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
              child: Text(
                '取消',
                style: gInfoTextStyle,
              ),
            ),
          ],
          content: Container(
            height: 52.0,
            child: Text(
              "确定重置并重新录制测评本题吗？",
              style: gInfoTextStyle,
            ),
          ),
        ),
      );
    }
    // if (widget.dataPage.hasRecordFile()) {
    // _playRecord();
    // }
    else if (widget.dataPage.isRecording()) {
      _stopRecording(subButShow);
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
          widget.wrongsShow = false;
        });
      }
    }
  }

  Future<void> _stopRecording(bool subButShow) async {
    if (!widget.dataPage.isRecording()) return;
    final recordRet = await _audioRecorder.stop();
    widget.dataPage.setFilePath(recordRet!);
    setState(() {
      widget.dataPage.setRecording(false);
      widget.dataPage.setUploading(true);
      widget.wrongsShow = false;
    });
    // ---------------- test !!!
    await widget.dataPage.postAndGetResultXf(widget.add2Mis, widget.valueIdx);
    print(widget.dataPage.dataOneResultCard!.cpsrcdId);
    setState(() {
      widget.dataPage.setUploading(false);
      if (subButShow)
        widget.wrongsShow = true;
      else
        widget.wrongsShow = false;
      print("------------");
      print(widget.dataPage.dataOneResultCard!.cpsrcdId);
      widget.dataPage.setStartPlaying(false);
      widget.dataPage.setRecording(false);
    });
  }

  void _retryRecording() {
    if (!widget.dataPage.hasRecordFile()) return;
    if (widget.dataPage.isRecording() || widget.dataPage.isUploading()) return;
    // _audioPlayer.stop();
    setState(() {
      widget.dataPage.setFilePath('');
      widget.dataPage.dataOneResultCard = null;
      widget.wrongsShow = false;
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
    _audioPlayer.play(ap.UrlSource(widget.dataPage.audioUrl.toString()));
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
    print(widget.dataPage.audioUrl);
    if (widget.dataPage.audioUrl == "" || widget.dataPage.audioUrl == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ComponentSubtitle(
            label: '没有示例语音',
            style: gSubtitleStyle,
          )
        ],
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

  List<String> wrongSheng = [];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // tags -------
    List<Widget> listTags = List.empty(growable: true);
    if (widget.dataPage.tags == [] || widget.dataPage.tags == null) {
      listTags.add(ComponentSubtitle(
        label: '无',
        style: gSubtitleStyle,
      ));
    } else {
      for (var tag in widget.dataPage.tags!) {
        if (listTags.length != 0) listTags.add(SizedBox(width: 5));
        listTags.add(Padding(
          padding: EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: gColorFFFFFFRGBA,
            ),
            child: Text(
              tag.name.toString(),
              style: gInfoTextStyle,
            ),
          ),
        ));
      }
    }
    // todo edit tags name
    List<Widget> tags = List.empty(growable: true);
    tags.addAll(
      <Widget>[
        Center(
            child: Text(widget.typeIdx +
                widget.dataPage.description! +
                widget.typeScore)),
        // 错题出处
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Row(
            children: [
              ComponentSubtitle(
                label: widget.nowIdx != -1 ? '题目进度：' : "",
                style: gInfoTextStyle,
              ),
              ComponentSubtitle(
                label: widget.nowIdx != -1
                    ? widget.nowIdx.toString() +
                        "/" +
                        widget.questionNum.toString()
                    : "",
                style: gInfoTextStyle2,
              )
            ],
          ),
        ),
        widget.subButShow
            ? ComponentSubtitle(
                label: ("类型：" + widget.dataPage.type.toString() ?? "") +
                    "   难度：" +
                    (widget.dataPage.difficulty.toString() ?? ""),
                style: gInfoTextStyle)
            : Container(),
        widget.subButShow
            ? Padding(
                padding: EdgeInsets.only(top: 0),
                child: Row(
                  children: [
                    ComponentSubtitle(
                      label: '标签：',
                      style: gInfoTextStyle,
                    ),
                    SizedBox(
                        width: screenSize.width * 0.8,
                        height: 30,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listTags.length,
                            itemBuilder: (BuildContext context, int index) {
                              return listTags[index];
                            }))
                  ],
                ),
              )
            : Container(),
      ],
    );
    // tags -------

    // content head todo
    List<Widget> children = List.empty(growable: true);
    children.addAll(
      [
        Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: !widget.wrongsShow
                ? Text(
                    // widget.dataPage.getScoreDescString(!widget.titleShow),
                    "分数：" + widget.dataPage.score.toString(),
                    style: gInfoTextStyle,
                  )
                : Text(
                    // widget.dataPage.getScoreDescString(!widget.titleShow),
                    "分数：" + widget.dataPage.score.toString() + "    错题展示：",
                    style: gInfoTextStyle,
                  )),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Column(
              children: widget.dataPage.getRichText4Show(
                  widget.dataPage.refText ?? "",
                  widget.dataPage.pinyin ?? "",
                  widget.wrongsShow,
                  widget.dataPage.enablePinyin ?? false)),
        ),
      ],
    );



    return Scaffold(
        backgroundColor: gColorE1EBF5RGBA,
        appBar: AppBar(
          shadowColor: Color.fromARGB(0, 0, 0, 0),
          automaticallyImplyLeading: false,
          backgroundColor: gColorE1EBF5RGBA,
          toolbarHeight: 100.0,
          title: Container(
            child: Column(children: tags),
          ),
        ),
        body: ComponentShadowedContainer(
          color: gColorFFFFFFRGBA,
          shadowColor: gColorE1EBF5RGBA,
          edgesHorizon: 26.5,
          edgesVertical: 1,
          child: ListView(
            children: children,
          ),
        ),
        bottomNavigationBar: Container(
            height: 100.0,
            color: gColorE1EBF5RGBA,
            child: ListView(
              children: [
                widget.subButShow
                    ? Column(children: [
                        _buildExampleAudioPlayer(context),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(children: [
                                ComponentSubtitle(
                                  label: '拼音',
                                  style: gSubtitleStyle,
                                ),
                                Switch(
                                  value: widget.dataPage.enablePinyin!, //当前状态
                                  hoverColor: Colors.white,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    //重新构建页面
                                    setState(() {
                                      print(widget.dataPage.pinyin);
                                      widget.dataPage.enablePinyin = value;
                                    });
                                  },
                                )
                              ]),
                              Row(children: [
                                ComponentSubtitle(
                                  label: '科大讯飞',
                                  style: gSubtitleStyle,
                                ),
                                Switch(
                                  value: widget.valueIdx, //当前状态
                                  inactiveTrackColor: Colors.green,
                                  // hoverColor: Colors.white,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    //重新构建页面
                                    setState(() {
                                      print(widget.valueIdx ? "1" : "0");
                                      widget.valueIdx = value;
                                    });
                                  },
                                ),
                                ComponentSubtitle(
                                  label: '自研算法',
                                  style: gSubtitleStyle,
                                )
                              ])
                            ])
                      ])
                    : Column(children: [
                        _buildExampleAudioPlayer(context),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(children: [
                                ComponentSubtitle(
                                  label: '科大讯飞',
                                  style: gSubtitleStyle,
                                ),
                                Switch(
                                  value: widget.valueIdx, //当前状态
                                  inactiveTrackColor: Colors.green,
                                  // hoverColor: Colors.white,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    //重新构建页面
                                    setState(() {
                                      print(widget.valueIdx ? "1" : "0");
                                      widget.valueIdx = value;
                                    });
                                  },
                                ),
                                ComponentSubtitle(
                                  label: '自研算法',
                                  style: gSubtitleStyle,
                                ),
                              ])
                            ]),
                      ]),
                !widget.recordShow
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () =>
                                  _cbkRecordStop(widget.subButShow),
                              child: Container(
                                width: screenSize.width * 0.6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27),
                                  color: Colors.green[300],
                                  boxShadow: [
                                    BoxShadow(
                                      color: gColorE1EBF5RGBA,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(
                                          1, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: widget.dataPage.isUploading()
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            strokeWidth: 4.0,
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: (Text(
                                                '评测进行中, 请稍等...',
                                                style: gSubtitleStyle,
                                              )),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              _recordIcon(),
                                              Text(
                                                (!widget.dataPage
                                                        .hasRecordFile())
                                                    ? (widget.dataPage
                                                            .isRecording()
                                                        ? '正在录音'
                                                        : '点击开始录音')
                                                    : '评测完成（再次点击可重新评测）',
                                                style: gSubtitleStyle,
                                              ),
                                            ],
                                          ),
                                          // color: gColorE3EDF7RGBA,
                                        ],
                                      ),
                              )),
                        ],
                      ),
              ],
            )));
  }
}
