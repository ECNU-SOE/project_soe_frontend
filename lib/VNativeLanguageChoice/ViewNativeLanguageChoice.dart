import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VAppHome/ViewAppHome.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/VExam/ViewExam.dart';

import 'DataNativeLanguage.dart';

Future<void> onChooseNativeLanguage(
    BuildContext context, http.Client client, int id) async {
  final response = await client.get(Uri.parse(
      'http://47.101.58.72:8002/api/common/v1/paper?token=xxx&languageId=$id'));
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final parsedId = decoded['data'];
  Navigator.pushReplacementNamed(context, ViewExam.routeName,
      arguments: ArgsViewExam(parsedId, '全面测试', ViewAppHome.routeName));
}

class _ViewNativeLanuageChooseImpl extends StatelessWidget {
  const _ViewNativeLanuageChooseImpl({
    super.key,
    required this.nativeLanguages,
  });
  final List<DataNativeLanuage> nativeLanguages;

  final String _title = '标题';
  final String _info = '选择你的母语';

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: nativeLanguages.length * 2 + 3,
      itemBuilder: (context, ib) {
        if (ib == 0) {
          return ListTile(
            title: Text(
              _title,
              textAlign: TextAlign.center,
              style: gTitleStyle,
            ),
          );
        }
        if (ib == 1) {
          return ListTile(
            title: Text(
              _info,
              textAlign: TextAlign.center,
              style: gTitleStyle,
            ),
          );
        }
        final i = ib - 2;
        if (!i.isOdd) return const Divider();
        final index = i ~/ 2;
        return ListTile(
          title: Text(
            nativeLanguages[index].label,
            style: gSubtitleStyle,
            textAlign: TextAlign.center,
          ),
          trailing: const Icon(
            Icons.flag,
            color: Colors.red,
          ),
          onTap: () {
            onChooseNativeLanguage(
                context, http.Client(), nativeLanguages[index].id);
          },
        );
      },
    );
  }
}

class ViewNativeLanuageChoose extends StatelessWidget {
  const ViewNativeLanuageChoose({super.key});
  static const String routeName = 'nlchoice';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<DataNativeLanuage>>(
        future: fetchNativeLanguages(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return _ViewNativeLanuageChooseImpl(
                nativeLanguages: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
