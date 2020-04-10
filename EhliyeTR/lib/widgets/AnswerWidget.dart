import 'package:ehliyet_app/blocs/ExamState.dart';
import 'package:ehliyet_app/blocs/theme.dart';
import 'package:ehliyet_app/class/question.dart';
import 'package:ehliyet_app/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswerWidget extends StatelessWidget {
  final String leading;
  final Answer answer;
  AnswerWidget({this.answer, this.leading});

  @override
  Widget build(BuildContext context) {
    bool selected = false;
    bool reveal = false;
    ExamState examState = Provider.of<ExamState>(context);
    ThemeChanger themeState = Provider.of<ThemeChanger>(context);
    if (examState.getSelected() == answer.id) selected = !selected;
    reveal = examState.getRevealState(examState.getCurrentIndex());
    if (reveal) {
      int correctID = examState.checkAnswer(examState.getCurrentIndex());
      Color color = Theme.of(context).buttonColor;
      Color color2 = Color.fromRGBO(60, 60, 60, 1);
      if (answer.id == correctID) {
        color = Color(0xFF7FAA98);
        color2 = Color.fromRGBO(100, 200, 100, 1);
      } else if (selected) {
        color = Color(0xFFf7b186);
        color2 = Color.fromRGBO(200, 100, 100, 1);
      }
      return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            // BoxShadow(
            //     color: themeState.getDark() ? Colors.black54 : Colors.black,
            //     offset: Offset(4.0, 4.0),
            //     blurRadius: 8.0,
            //     spreadRadius: 0.2),
            // BoxShadow(
            //     color: themeState.getDark() ? Colors.grey[850] : Colors.grey[800],
            //     offset: Offset(-4.0, -4.0),
            //     blurRadius: 8.0,
            //     spreadRadius: 0.2),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
              child: Text(leading,
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 6,
                      color: Theme.of(context).buttonColor,
                      fontWeight: FontWeight.w900)),
              backgroundColor: Color(0xFF7c16c84)),
          title: Text(answer.answerText, style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 5,
                color: Color(0xFF7c16c84),
                fontWeight: FontWeight.bold),),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            color: selected
                ? Color(0xFFEF8262)
                //: Theme.of(context).accentColor.withRed(120).withGreen(150).withBlue(200),//Color.fromRGBO(150, 150, 150, 1),
                : Theme.of(context).buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              // BoxShadow(
              //     color: themeState.getDark() ? Colors.black54 : Colors.black,
              //     offset: Offset(4.0, 4.0),
              //     blurRadius: 8.0,
              //     spreadRadius: 0.2),
              // BoxShadow(
              //     color: themeState.getDark() ? Colors.grey[850] : Colors.grey[800],
              //     offset: Offset(-4.0, -4.0),
              //     blurRadius: 8.0,
              //     spreadRadius: 0.2),
            ]),
        child: ListTile(
          onTap: () {
            int temp = answer.id;
            if (examState.getSelected() == answer.id) temp = -1;
            examState.setSelected(temp);
          },
          leading: CircleAvatar(
              child: Text(leading,
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).buttonColor,
                      fontWeight: FontWeight.w900)),
              backgroundColor: Color(0xFF7c16c84)),
          title: Text(
            answer.answerText,
            style: TextStyle(
              fontSize: 16,
                color: selected
                    ? Theme.of(context).buttonColor
                    : Color(0xFF7c16c84),
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
