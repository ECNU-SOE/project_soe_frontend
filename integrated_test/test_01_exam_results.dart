import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:project_soe/src/VFullExam/ViewFullExamResults.dart' as results;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('exam_results_view', () {
    testWidgets('testing exam results view...', (tester) async {
      results.FullExaminationResult;
      await tester.pumpAndSettle();
    });
  });
}
