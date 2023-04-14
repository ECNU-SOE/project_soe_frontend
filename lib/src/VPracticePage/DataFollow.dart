import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:mime/mime.dart' as mime;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

import 'package:project_soe/src/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/src/CComponents/LogicPingyinlizer.dart'
    as pinyinlizer;
import 'package:project_soe/src/VExam/MsgQuestion.dart';
import 'package:project_soe/src/VExam/ViewExamResults.dart';

class DataFollowPage {}
