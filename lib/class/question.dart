class Question {
  final int id;
  final String subject;
  final String questionText;
  final List<Answer> answers;
  final int correctID;

  Question(
      {this.id, this.subject, this.questionText, this.answers, this.correctID});

  Map<String, dynamic> toMap() {
    return {
      'Content': questionText,
      'ConImage': '',
      'Ans1': answers[0].answerText,
      'A1Image': '',
      'Ans2': answers[1].answerText,
      'A2Image': '',
      'Ans3': answers[2].answerText,
      'A3Image': '',
      'Ans4': answers[3].answerText,
      'A4Image': '',
      'CorrectAns': correctID,
      'Topic': subject,
      'Asked': '0'
    };
  }

  fromMap(Map<String, dynamic> map){
    return Question(
      id: map['id'],
      subject: map['Topic'],
      questionText: map['Content'],
      answers: [Answer(id: 1, answerText: map['Ans1']),
                Answer(id: 2, answerText: map['Ans2']),
                Answer(id: 3, answerText: map['Ans3']),
                Answer(id: 4, answerText: map['Ans4']),],
      correctID: map['CorrectAns']
    );
  }
}

class Answer {
  final int id;
  final String answerText;

  Answer({this.id, this.answerText});
}
