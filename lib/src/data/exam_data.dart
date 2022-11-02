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

//   factory FullExamData.fromJson(Map<String, dynamic> json) {
//     return FullExamData(
//       singleWords: json['singleWords'],
//       doubleWords: json['doubleWords'],
//       sentances: json['sentances'],
//     );
//   }
