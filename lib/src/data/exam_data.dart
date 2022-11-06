class FullExamData {
  final List<String> singleWords;
  final List<String> doubleWords;
  final List<String> sentances;
  const FullExamData(
    this.singleWords,
    this.doubleWords,
    this.sentances,
  );
}

class QuestionData {
  final String id;
  final int type;
  final String label;
  const QuestionData({
    required this.id,
    required this.type,
    required this.label,
  });
  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      id: json['id'] as String,
      type: json['type'] as int,
      label: json['refText'] as String,
    );
  }
}

//   factory FullExamData.fromJson(Map<String, dynamic> json) {
//     return FullExamData(
//       singleWords: json['singleWords'],
//       doubleWords: json['doubleWords'],
//       sentances: json['sentances'],
//     );
//   }
