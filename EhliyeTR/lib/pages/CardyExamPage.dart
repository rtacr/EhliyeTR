import 'package:ehliyet_app/blocs/ExamState.dart';
import 'package:ehliyet_app/blocs/theme.dart';
import 'package:ehliyet_app/class/exam.dart';
import 'package:ehliyet_app/class/question.dart';
import 'package:ehliyet_app/utils/SizeConfig.dart';
import 'package:ehliyet_app/utils/dbUtils.dart';
import 'package:ehliyet_app/widgets/QuestionWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardyExamPage_State extends StatelessWidget {
  final Exam exam;
  CardyExamPage_State(this.exam);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ExamState(
            currentIndex: 0,
            exam: exam,
            revealList:
                List<bool>.generate(exam.questions.length, (i) => false)),
        child: CardyExamPage(exam));
  }
}

class CardyExamPage extends StatelessWidget {
  final Exam exam;
  CardyExamPage(this.exam);

  @override
  Widget build(BuildContext context) {
    ExamState examState = Provider.of<ExamState>(context);
    double initalX = 0;

    showFinishDialog(BuildContext c) {
      showModalBottomSheet(
          elevation: 0,
          backgroundColor: Colors.transparent,
          context: c,
          builder: (c) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Theme.of(context).scaffoldBackgroundColor),
              height: SizeConfig.blockSizeVertical * 20,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Text("Testi bitirmek istediğinize emin misiniz?",
                      style: TextStyle(color: nicePink)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Geri Dön",
                            style: TextStyle(color: nicePink),
                          )),
                      RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            examState.revealAll(c);

                          },
                          elevation: 0,
                          child: Text(
                            "Bitir",
                            style: TextStyle(color: nicePink),
                          ),
                          color: Theme.of(context).cardColor)
                    ],
                  )
                ]),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "${examState.getCurrentIndex() + 1} / ${exam.questions.length}",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF7c16c84),
              letterSpacing: 1.25),
        ),
        centerTitle: true,
        actions: [
          // For resetting exam
          // IconButton(
          //   icon: Icon(Icons.loop),
          //   onPressed: () {
          //     examState.resetReveal();
          //   },
          // )
        ],
      ),
      body: Container(
          alignment: Alignment.center,
          child: Container(
            height: SizeConfig.safeBlockVertical * 80,
            width: SizeConfig.safeBlockHorizontal * 90,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF7c16c84), width: 2),
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                initalX = details.localPosition.dx;
              },
              onHorizontalDragEnd: (details) {
                double distance = details.velocity.pixelsPerSecond.dx;
                if (distance.abs() > 500) {
                  if (distance > 0)
                    examState.changeQuestion(examState.getCurrentIndex() - 1);
                  else
                    examState.changeQuestion(examState.getCurrentIndex() + 1);
                }
              },
              child:
                  QuestionWidget(exam.questions[examState.getCurrentIndex()]),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 24),
        alignment: Alignment.center,
        width: SizeConfig.safeBlockHorizontal * 25,
        height: SizeConfig.safeBlockVertical * 7,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0xFFf8f1d6),
            border: Border.all(width: 2, color: nicePink)),
        child: InkWell(
          onTap: () {
            showFinishDialog(context);
            // examState.revealAll();
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              Icon(
                Icons.check,
                size: 30,
                color: Color(0xFF7c16c84),
              ),
              SizedBox(width: 10),
              Text("Bitir",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF7c16c84),
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   shape: RoundedRectangleBorder(),
      //   backgroundColor: Color(0xFFf8f1d6),
      //   label: Text("Bitir",
      //       style: TextStyle(
      //           color: Color(0xFF7c16c84), fontWeight: FontWeight.bold)),
      //   icon: Icon(
      //     Icons.check,
      //     color: Color(0xFF7c16c84),
      //   ),
      //   onPressed: () {
      //     examState.revealAll();
      //   },
      // ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        height: SizeConfig.blockSizeVertical * 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.skip_previous, size: 36),
                onPressed: () {
                  examState.changeQuestion(examState.getCurrentIndex() - 1);
                },
              ),
            ),
            Flexible(
              flex: 8,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: exam.answers.length,
                    itemBuilder: (context, index) {
                      String i = exam.getAnswer(index).toString();
                      Color clr = Theme.of(context).cardColor;
                      if (exam.answers[index] != -1) {
                        if (examState.getRevealState(index)) {
                          if (exam.answers[index] ==
                              examState.checkAnswer(index)) {
                            clr = Color(0xFF7FAA98);
                          } else {
                            clr = Color(0xFFf7b186);
                          }
                        } else {
                          clr = Color(0xFFd45656);
                        }
                      }
                      return InkWell(
                        onTap: () {
                          examState.changeQuestion(index);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              color: clr,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          width: SizeConfig.blockSizeHorizontal * 7,
                          height: SizeConfig.blockSizeVertical * 10,
                          child: Center(
                              child: Text("${index + 1}",
                                  style: TextStyle(
                                      color: Color(0xFFf8f1d6),
                                      fontSize: 18))),
                          // child: Text(exam.getAnswer(index).toString()),
                        ),
                      );
                    },
                  )),
            ),
            Flexible(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.skip_next, size: 36),
                onPressed: () {
                  examState.changeQuestion(examState.getCurrentIndex() + 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
