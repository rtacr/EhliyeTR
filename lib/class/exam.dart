import 'dart:math';

import 'package:ehliyet_app/class/question.dart';
import 'package:ehliyet_app/utils/dbUtils.dart';

class Exam {
  List<Question> questions;
  String examType;
  List<int> answers;

  Exam({this.questions, this.examType, this.answers});

  getAnswer(int index) {
    return answers[index];
  }

  setAnswer(int index, int id) {
    answers[index] = id;
  }

  Future<Exam> createExam() async {
    DatabaseUtils db = DatabaseUtils();

    int questionCount = 25;
    List<int> topicsPercents = [4, 11, 10];
    List<String> topicNames = [
      "İlk Yardım",
      "Trafik ve Çevre Bilgisi",
      "Motor ve Araç Tekniği"
    ];

    List<Question> topic1List = await db.getAllFromTopic(topicNames[0]);
    List<Question> topic2List = await db.getAllFromTopic(topicNames[1]);
    List<Question> topic3List = await db.getAllFromTopic(topicNames[2]);
    List<Question> questionList = new List<Question>();

    for (var i = 0; i < topicsPercents[0]; i++) {
      Random rnd = Random();
      int randIndex = rnd.nextInt(topic1List.length);
      questionList.add(topic1List[randIndex]);
      topic1List.removeAt(randIndex);
    }

    for (var i = 0; i < topicsPercents[1]; i++) {
      Random rnd = Random();
      int randIndex = rnd.nextInt(topic2List.length);
      questionList.add(topic2List[randIndex]);
      topic2List.removeAt(randIndex);
    }

    for (var i = 0; i < topicsPercents[2]; i++) {
      Random rnd = Random();
      int randIndex = rnd.nextInt(topic3List.length);
      questionList.add(topic3List[randIndex]);
      topic3List.removeAt(randIndex);
    }

    return Exam(
        examType: "Deneme",
        questions: questionList,
        answers: List<int>.generate(questionList.length, (index) => -1));
  }
}
