import 'package:ehliyet_app/blocs/theme.dart';
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

  revealAll(BuildContext c) {
    TestResult tr = TestResult().cleanResult();
    StatisticsDB sdb = StatisticsDB();
    for (var i = 0; i < exam.questions.length; i++) {
      ///Mark as asked if question is answered.
      ///If not just take it as [wrong]
      if (exam.answers[i] == exam.questions[i].correctID) {
        tr.correctAnswer(exam.questions[i].subject);
        DatabaseUtils().markQuestion(exam.questions[i].id);
      } else if (exam.answers[i] == -1) {
        tr.wrongAnswer(exam.questions[i].subject);
      } else {
        tr.wrongAnswer(exam.questions[i].subject);
        DatabaseUtils().markQuestion(exam.questions[i].id);
      }
      revealList[i] = true;
      notifyListeners();
    }
    sdb.insertTest(tr);
    showDialog(
        context: c,
        builder: (c) {
          return Dialog(
              child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF7c16c84), width: 2),
                color: Theme.of(c).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            height: MediaQuery.of(c).size.height / 3,
            child: Column(
              children: [
                Text(
                  "Sınav Sonucunuz\n${tr.questionCount - tr.falseCount} doğru, ${tr.falseCount} yanlış",
                  style: TextStyle(color: nicePink),
                ),
                Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(c).pop();
                        Navigator.of(c).pop();
                      },
                      child: Text(
                        "Ana Menüye Dön",
                        style: TextStyle(color: nicePink),
                      )),
                  RaisedButton(
                      child: Text(
                        "Kontrol Et",
                        style: TextStyle(color: nicePink),
                      ),
                      onPressed: () {
                        Navigator.of(c).pop();

                      })
                ])
              ],
            ),
          ));
        });
  }

  revealOnly(int index) {
    revealList[index] = true;
    notifyListeners();
  }

  bool getRevealState(int index) => revealList[index];

  resetReveal() {
    for (var i = 0; i < exam.questions.length; i++) {
      revealList[i] = false;
      notifyListeners();
    }
  }
}
