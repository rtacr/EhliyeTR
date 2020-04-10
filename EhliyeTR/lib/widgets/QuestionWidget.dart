import 'package:ehliyet_app/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:ehliyet_app/class/question.dart';
import 'package:ehliyet_app/widgets/AnswerWidget.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  QuestionWidget(this.question);
  
  final List<String> alphabet = ["A", "B", "C", "D"];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text(question.questionText.replaceAll("\\n", "\n"),
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: SizeConfig.safeBlockHorizontal * 5, color: Color(0xFF7c16c84))),
          SizedBox(height: 50),
          Container(
            child: Column(
              children: List<Widget>.generate(question.answers.length, (index) {
                return Container(
                  padding: question.answers.length == index ?EdgeInsets.only(bottom: 0) :EdgeInsets.only(bottom: 10, top: 10, left: 10),
                  child: AnswerWidget(
                          answer: question.answers[index],
                          leading: alphabet[index]),
                );
              }) 
            ),
          )
        ],
      ),
    );
  }
}
