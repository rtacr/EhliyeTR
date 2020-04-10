import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ehliyet_app/class/exam.dart';
import 'package:ehliyet_app/class/question.dart';
import 'package:ehliyet_app/utils/dbUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

exam() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.containsKey("lastFetch")){ 
    DateTime lastFetch = DateTime.parse(await prefs.getString("last_fetch"));
    if(DateTime.now().difference(lastFetch) < Duration(days: 1))  return;
  }
  
  var result = await getData();
  await prefs.setString("last_fetch", DateTime.now().toIso8601String());
  DatabaseUtils db = DatabaseUtils();

  for (var index = 0;
      index < result['valueRanges'][0]['values'].length;
      index++) {
    Question qs = Question(
        id: index + 1,
        subject: result['valueRanges'][11]['values'][index][0],
        questionText: result['valueRanges'][0]['values'][index][0],
        answers: [
          Answer(
              id: 0, answerText: result['valueRanges'][2]['values'][index][0]),
          Answer(
              id: 1, answerText: result['valueRanges'][4]['values'][index][0]),
          Answer(
              id: 2, answerText: result['valueRanges'][6]['values'][index][0]),
          Answer(
              id: 3, answerText: result['valueRanges'][8]['values'][index][0]),
        ],
        correctID: int.parse(
            result['valueRanges'][10]['values'][index][0].toString()));
    db.insertQuestion(qs);
  }
}

getData() async {
  //normal sorular = '1vf8aj8-8Y_QrTP3VMW8L-ceQabLVnFnh0q5OJftvmzY';
  var spreadsheetID = '1ldCS_12RK4uVkDC94umn2_kRuxzQIPmAVn895j_jVQE';
  var apiKey = 'AIzaSyC6vtjhopaYN0VgaBsHz8Acei2Kse3iRSk';
  var url = 'https://sheets.googleapis.com/v4/spreadsheets/${spreadsheetID}/' +
      'values:batchGet?ranges=A2%3AA&ranges=B2%3AB&ranges=C2%3AC&ranges=D2%3AD' +
      '&ranges=E2%3AE&ranges=F2%3AF&ranges=G2%3AG&ranges=H2%3AH&ranges=I2%3AI&ranges=J2%3AJ&ranges=K2%3AK&ranges=L2%3AL' +
      '&key=${apiKey}';
  var response = await http.get(url, headers: {"Accept": "application/json"});
  return json.decode(response.body);
}
