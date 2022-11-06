import 'package:flutter/material.dart';
import 'package:project_soe/src/app_home/app_home.dart';
import '../components/voice_input.dart';
import '../data/params.dart';
import '../data/styles.dart';
/*
class FullExaminationProcess extends StatelessWidget {
  final ValueNotifier<double> finishValue;
  const FullExaminationProcess({
    super.key,
    required this.finishValue,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: finishValue,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: LinearProgressIndicator(value: finishValue.value),
        );
      },
    );
  }
}

class FullExamination extends StatelessWidget {
  final List<String>? singleWords;
  final List<String>? doubleWords;
  final List<String>? sentances;
  static const String routeName = 'fullexam';
  FullExamination(
      {super.key,
      required this.singleWords,
      required this.doubleWords,
      required this.sentances});
  // private variables
  final List<VoiceInputComponent> _singleComponents = [];
  final List<VoiceInputComponent> _doubleComponents = [];
  final List<VoiceInputComponent> _sentanceComponents = [];
  bool _isFirstBuild = true;
  final ValueNotifier<double> _finishValueNotifier = ValueNotifier<double>(0.0);
  // 计算完成度, 用于ProcessBar的显示.
  double _calculateFinishValue() {
    int process = 0;
    int total = 0;
    for (VoiceInputComponent compo in _singleComponents) {
      total += gFullExaminationWeightSingleWords;
      if (compo.recordPath != '') {
        process += gFullExaminationWeightSingleWords;
      }
    }
    for (VoiceInputComponent compo in _doubleComponents) {
      total += gFullExaminationWeightDoubleWords;
      if (compo.recordPath != '') {
        process += gFullExaminationWeightDoubleWords;
      }
    }
    for (VoiceInputComponent compo in _sentanceComponents) {
      total += gFullExaminationWeightSentances;
      if (compo.recordPath != '') {
        process += gFullExaminationWeightSentances;
      }
    }
    return process.toDouble() / total.toDouble();
  }

  // 构造VoiceInputComponent的函数, 第一次构造时将其加入List
  void _buildVoiceInputs(List<Widget> children, List<String> wordLists,
      int columnCount, List<VoiceInputComponent>? ret, bool isFirst) {
    int count = 0;
    List<Widget> rows = [];
    List<VoiceInputComponent> voiceInputs = [];
    for (var word in wordLists) {
      VoiceInputComponent component = VoiceInputComponent(label: word);
      voiceInputs.add(component);
      if (isFirst) {
        ret!.add(component);
        component.addListener(() {
          _finishValueNotifier.value = _calculateFinishValue();
        });
      }
      count++;
      if (count == columnCount) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: List<VoiceInputComponent>.from(voiceInputs),
        ));
        voiceInputs.clear();
        count = 0;
      }
    }
    if (count != 0) {
      rows.add(Row(
        children: voiceInputs,
      ));
    }
    children.addAll(rows);
  }

  // 检查是否完成所有的试题
  bool _checkFinishAll() {
    for (VoiceInputComponent compo in _singleComponents) {
      if (compo.recordPath == '') {
        return false;
      }
    }
    for (VoiceInputComponent compo in _doubleComponents) {
      if (compo.recordPath == '') {
        return false;
      }
    }
    for (VoiceInputComponent compo in _sentanceComponents) {
      if (compo.recordPath == '') {
        return false;
      }
    }
    return true;
  }

  // TODO 弹出SnackBar 提示尚未完成测试.
  void _showUnfinishedTip(BuildContext context) {
    Navigator.pushNamed(context, ApplicationHome.routeName);
  }

  // TODO 提交测试
  void _submitFullExam(BuildContext context) {
    Navigator.pushNamed(context, ApplicationHome.routeName);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    rows.add(FullExaminationProcess(finishValue: _finishValueNotifier));
    rows.add(Row(children: const [
      Text("Single Words", style: gFullExaminationSubTitleStyle)
    ]));
    _buildVoiceInputs(rows, singleWords!, 4, _singleComponents, _isFirstBuild);
    rows.add(Row(children: const [
      Text("Double Words", style: gFullExaminationSubTitleStyle)
    ]));
    _buildVoiceInputs(rows, doubleWords!, 2, _doubleComponents, _isFirstBuild);
    rows.add(Row(children: const [
      Text("Sentances", style: gFullExaminationSubTitleStyle)
    ]));
    _buildVoiceInputs(rows, sentances!, 1, _sentanceComponents, _isFirstBuild);
    _calculateFinishValue();
    _isFirstBuild = false;
    rows.add(ElevatedButton(
      child: const Text(
        'Submit',
        style: gFullExaminationSubTitleStyle,
      ),
      onPressed: () {
        if (_checkFinishAll()) {
          _submitFullExam(context);
        } else {
          _showUnfinishedTip(context);
        }
      },
    ));
    return Scaffold(
      body: ListView(children: rows),
    );
  }
}
*/

// FIXME 22.11.6 这个应该从服务器获取
final wordList = [
  ['a', 'b', 'c', 'd', 'e'],
  ['aa', 'bb', 'cc', 'dd'],
  ['aaaaaaaaaaaaaaaaaaaaaaaaaa'],
];

class _FullExaminationState extends State<FullExamination> {
  _FullExaminationState();
  int _index = 0;
  final _listSize = wordList.length;

  void _forward() {
    if (_index <= 0) {
      return;
    } else {
      setState(() {
        _index = _index - 1;
        _process.value = _index.toDouble() / _listSize.toDouble();
      });
    }
  }

  void _next() {
    if (_index >= (_listSize - 1)) {
      return;
    } else {
      setState(() {
        _index = _index + 1;
        _process.value = _index.toDouble() / _listSize.toDouble();
      });
    }
  }

  final ValueNotifier<double> _process = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        title: Column(
          children: [
            AnimatedBuilder(
              animation: _process,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: LinearProgressIndicator(
                      color: Colors.red, value: _process.value),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _forward,
                  child: Icon(Icons.arrow_left),
                  style: gFullExaminationNavButtonStyle,
                ),
                const Text(
                  'Full Examination',
                  style: gFullExaminationTitleStyle,
                ),
                ElevatedButton(
                  onPressed: _next,
                  child: Icon(Icons.arrow_right),
                  style: gFullExaminationNavButtonStyle,
                ),
              ],
            ),
          ],
        ),
      ),
      body: VoiceInputPage(wordList: wordList[_index]),
    );
  }
}

class FullExamination extends StatefulWidget {
  const FullExamination({super.key});
  static const String routeName = 'fullExam';
  @override
  State<StatefulWidget> createState() => _FullExaminationState();
}
