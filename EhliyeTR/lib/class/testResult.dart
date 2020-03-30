import 'package:ehliyet_app/utils/constantValues.dart';

class TestResult {
  int questionCount;
  int falseCount;
  int t1True;
  int t1False;
  int t2True;
  int t2False;
  int t3True;
  int t3False;
  String dateTime;

  TestResult(
      {this.questionCount,
      this.falseCount,
      this.t1True,
      this.t1False,
      this.t2True,
      this.t2False,
      this.t3True,
      this.t3False,
      this.dateTime});

  TestResult cleanResult() {
    return TestResult(
        questionCount: 0,
        falseCount: 0,
        t1False: 0,
        t1True: 0,
        t2False: 0,
        t2True: 0,
        t3False: 0,
        t3True: 0,
        dateTime: DateTime.now().toIso8601String());
  }

  Map<String, dynamic> toMap() {
    return {
      'questionCount': questionCount,
      'falseCount': falseCount,
      't1True': t1True,
      't1False': t1False,
      't2True': t2True,
      't2False': t2False,
      't3True': t3True,
      't3False': t3False,
      'dateTime': dateTime,
    };
  }

  fromMap(Map<String, dynamic> map) {
    return TestResult(
        questionCount: map['questionCount'],
        falseCount: map['falseCount'],
        t1True: map['t1True'],
        t1False: map['t1False'],
        t2True: map['t2True'],
        t2False: map['t2False'],
        t3True: map['t3True'],
        t3False: map['t3False'],
        dateTime: map['dateTime']);
  }

  String dtFormat(DateTime date){
    return "${date.day}/${date.month.toString().padLeft(2, '0')}/${date.year.remainder(2000)}\n${date.hour}:${date.minute}";
  }

  incQc() {
    questionCount = questionCount + 1;
  }

  correctAnswer(String topic) {
    switch (topic) {
      case topic1:
        t1True += 1;
        break;
      case topic2:
        t2True += 1;
        break;
      case topic3:
        t3True += 1;
        break;
      default:
    }
    incQc();
  }

  wrongAnswer(String topic) {
    switch (topic) {
      case topic1:
        t1False += 1;
        break;
      case topic2:
        t2False += 1;
        break;
      case topic3:
        t3False += 1;
        break;
      default:
    }
    falseCount += 1;
    incQc();
  }
}
