import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../full_exam/full_exam.dart';
import 'package:http/http.dart' as http;

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

Future<String> getStringbyNLId(int id) async {
  final list = await fetchNativeLanguages(http.Client());
  for (final item in list) {
    if (item.id == id) {
      return item.label;
    }
  }
  return '';
}
