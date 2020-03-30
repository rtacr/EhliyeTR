import 'package:ehliyet_app/class/exam.dart';
import 'package:ehliyet_app/class/question.dart';
import 'package:ehliyet_app/class/testResult.dart';
import 'package:ehliyet_app/utils/dbUtils.dart';
import 'package:flutter/material.dart';

class ExamState with ChangeNotifier {
  int currentIndex;
  Exam exam;
  List<bool> revealList;
  ExamState({this.currentIndex, this.exam, this.revealList});

  getCurrentIndex() => currentIndex;

  changeQuestion(int index) {
    if (index < exam.questions.length && index >= 0) {
      currentIndex = index;
      notifyListeners();
    }
  }

  getSelected() {
    return exam.getAnswer(currentIndex);
  }

  setSelected(int id) {
    exam.answers[currentIndex] = id;
    notifyListeners();
  }

  getAnswer(int index) {
    return exam.answers[index];
  }

  checkAnswer(index) {
    return exam.questions[index].correctID;
  }

  revealAll() {
    TestResult tr = TestResult().cleanResult();
    StatisticsDB sdb = StatisticsDB();
    for (var i = 0; i < exam.questions.length; i++) {
      ///Mark as asked if question is answered. 
      ///If not just take it as [wrong]
      if (exam.answers[i] == exam.questions[i].correctID) {
        tr.correctAnswer(exam.questions[i].subject);
        DatabaseUtils().markQuestion(exam.questions[i].id);
      } else if(exam.answers[i] == -1){
        tr.wrongAnswer(exam.questions[i].subject);
      }else{
        tr.wrongAnswer(exam.questions[i].subject);
        DatabaseUtils().markQuestion(exam.questions[i].id);
      }
      revealList[i] = true;
      notifyListeners();
    }
    sdb.insertTest(tr);
  }

  revealOnly(int index) {
    revealList[index] = true;
    notifyListeners();
  }

  getRevealState(int index) => revealList[index];

  resetReveal() {
    for (var i = 0; i < exam.questions.length; i++) {
      revealList[i] = false;
      notifyListeners();
    }
  }
}
