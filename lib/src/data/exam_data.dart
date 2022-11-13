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

enum QuestionType {
  word,
  sentance,
  poem,
  article,
}

QuestionType questionTypeFromInt(int x) {
  switch (x) {
    case 1:
      return QuestionType.word;
    case 2:
      return QuestionType.sentance;
    case 5:
      return QuestionType.poem;
    case 3:
      return QuestionType.article;
    default:
      throw ("No Such Question Type");
  }
}

class QuestionPageData {
  final QuestionType type;
  final List<QuestionData> questionList;
  const QuestionPageData({
    required this.type,
    required this.questionList,
  });
}

class QuestionData {
  final String id;
  final int order;
  final String label;
  const QuestionData({
    required this.id,
    required this.order,
    required this.label,
  });
  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      id: json['id'] as String,
      order: json['order'] as int,
      label: json['refText'] as String,
    );
  }
}
