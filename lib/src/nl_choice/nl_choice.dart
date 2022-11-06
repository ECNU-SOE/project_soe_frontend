import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../full_exam/full_exam.dart';
import 'package:http/http.dart' as http;

import '../data/styles.dart';

class NativeLanguageData {
  final int id;
  final String label;
  const NativeLanguageData({
    required this.id,
    required this.label,
  });
  factory NativeLanguageData.fromJson(Map<String, dynamic> json) {
    return NativeLanguageData(
      id: json['id'] as int,
      label: json['motherTongue'] as String,
    );
  }
}

List<NativeLanguageData> parseNativeLanguageData(http.Response response) {
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final parsed = decoded['data']['languages'].cast<Map<String, dynamic>>();
  return parsed
      .map<NativeLanguageData>((json) => NativeLanguageData.fromJson(json))
      .toList();
}

Future<List<NativeLanguageData>> fetchNativeLanguages(
    http.Client client) async {
  final response = await client.get(
    Uri.parse('http://47.101.58.72:8002/api/common/v1/languages'),
  );
  return compute(parseNativeLanguageData, response);
}

Future<void> onChooseNativeLanguage(
    BuildContext context, http.Client client, int id) async {
  final response = await client.get(Uri.parse(
      'http://47.101.58.72:8002/api/common/v1/paper?token=xxx&languageId=$id'));
  final u8decoded = utf8.decode(response.bodyBytes);
  final decoded = jsonDecode(u8decoded);
  final parsedId = decoded['data'];
  Navigator.pushNamed(context, FullExamination.routeName,
      arguments: (parsedId));
}

class NativeLanguageList extends StatelessWidget {
  const NativeLanguageList({
    super.key,
    required this.nativeLanguages,
  });
  final List<NativeLanguageData> nativeLanguages;

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
              style: gNativeLanguageChooseTitleStyle,
            ),
          );
        }
        if (ib == 1) {
          return ListTile(
            title: Text(
              _info,
              textAlign: TextAlign.center,
              style: gNativeLanguageChooseInfoStyle,
            ),
          );
        }
        final i = ib - 2;
        if (!i.isOdd) return const Divider();
        final index = i ~/ 2;
        return ListTile(
          title: Text(
            nativeLanguages[index].label,
            style: gNativeLanguageChooseListStyle,
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

class NativeLanguageChoice extends StatelessWidget {
  const NativeLanguageChoice({super.key});
  static const String routeName = 'nlchoice';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<NativeLanguageData>>(
        future: fetchNativeLanguages(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return NativeLanguageList(nativeLanguages: snapshot.data!);
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
