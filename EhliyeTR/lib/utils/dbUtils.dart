import 'package:ehliyet_app/class/question.dart';
import 'package:ehliyet_app/class/testResult.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

///For questions
class DatabaseUtils {
  var tableName = 'QUESTIONS';
  var initQuery =
      'CREATE TABLE QUESTIONS (id INTEGER PRIMARY KEY, Content TEXT, ConImage TEXT,' +
          'Ans1 TEXT, A1Image TEXT, Ans2 TEXT, A2Image TEXT, Ans3 TEXT, A3Image TEXT, Ans4 TEXT, A4Image TEXT,' +
          'CorrectAns INTEGER, Topic TEXT, Asked INTEGER); ';

  Future<Database> database() async {
    var path = await getPath();

    return openDatabase(path, version: 1, onOpen: (db) {
      var a = (db.execute("Select * from $tableName"));
      if (a == null) {
      }
    }, onCreate: (Database db, int version) async {
      await db.execute(initQuery);
      await db.execute('CREATE TABLE Statistics' +
          ' (id INTEGER PRIMARY KEY, questionCount INTEGER, falseCount INTEGER,' +
          't1True INTEGER, t1False INTEGER, t2True INTEGER, t2False INTEGER, t3True INTEGER, t3False INTEGER,' +
          'dateTime Text)');
    });
  }

  ///Returns all the questions in the given [topic].
  Future<List<Question>> getAllFromTopic(String topic) async {
    var path = await getPath();
    Database database = await openDatabase(path, version: 1);
    String query = 'SELECT * FROM ' +
        tableName +
        ' Where Topic = \'' +
        topic +
        '\' and Asked = 0';
    var map = await database.rawQuery(query);
    return List<Question>.generate(
        map.length, (index) => Question().fromMap(map[index]));
  }

  ///Returns default Database path as String
  Future<String> getPath() async {
    var databasesPath = await getDatabasesPath();
    return databasesPath + '/ehliyapp.db';
  }

  destroyDatabase() async {
    var path = await getPath();
    await deleteDatabase(path);
  }

  //Temp
  Future<Question> getQuestion() async {
  
    var path = await getPath();
    Database database = await openDatabase(path, version: 1);

    var map = ((await database.rawQuery('SELECT * FROM ' + tableName))[0]);
    Question ques = Question();
    return ques.fromMap(map);
  }

  ///Insert Question To Database
  insertQuestion(Question question) async {
    var path = await getPath();
    Database db = await database();

    int check = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT Count(*) FROM ' +
            tableName +
            ' Where ID = ' +
            question.id.toString()));
    if (!(check > 0)) {
      await db.insert(tableName, question.toMap());
    }else{
      await db.update(tableName, question.toMap(), where: 'ID = ${question.id.toString()}');
    }
  }

  ///Mark as Asked.
  ///Sets [Asked] Value To [1]
  ///
  markQuestion(int id) async {
    var path = await getPath();
    Database db = await database();
    await db.execute(
        "UPDATE " + tableName + " SET ASKED = 1 Where ID = " + id.toString());
  }

  ///Get Question Count
  Future<int> questionCount() async {
    var path = await getPath();
    Database db = await database();
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT Count(*) FROM ' + tableName));
  }
}

///For statistics
class StatisticsDB {
  var statTable = 'Statistics';
  Future<Database> databaseInit() async {
    var path = await getPath();
    return openDatabase(path, version: 1, onOpen: (db) {
      var a = (db.query("$statTable"));
      if (a == null) {
      }
    }, onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE QUESTIONS (id INTEGER PRIMARY KEY, Content TEXT, ConImage TEXT,' +
              'Ans1 TEXT, A1Image TEXT, Ans2 TEXT, A2Image TEXT, Ans3 TEXT, A3Image TEXT, Ans4 TEXT, A4Image TEXT,' +
              'CorrectAns INTEGER, Topic TEXT, Asked INTEGER); ');
      await db.execute('CREATE TABLE ' +
          statTable +
          ' (id INTEGER PRIMARY KEY, questionCount INTEGER, falseCount INTEGER,' +
          't1True INTEGER, t1False INTEGER, t2True INTEGER, t2False INTEGER, t3True INTEGER, t3False INTEGER,' +
          'dateTime Text)');
    });
  }

  Future<String> getPath() async {
    var databasesPath = await getDatabasesPath();
    return databasesPath + '/ehliyapp.db';
  }

  insertTest(TestResult tr) async {
    var path = await getPath();
    Database db = await databaseInit();

    await db.insert(statTable, tr.toMap());
  }

  ///Get Question Count
  Future<int> questionCount() async {
    var path = await getPath();
    Database db = await databaseInit();
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT Count(*) FROM ' + statTable));
  }

  ///Return List Of Test Results
  Future<List<TestResult>> getAllResults() async {
    var path = await getPath();
    Database database = await databaseInit();     
    String query = "select * from $statTable";
    var map = await database.rawQuery(query);
    return List<TestResult>.generate(
        map.length, (index) => TestResult().fromMap(map[index]));
  }

  ///Delete table for test purposes
  deleteContent() async {
    var path = await getPath();
    Database db = await databaseInit();
    await db.rawQuery('DELETE FROM ' + statTable);
  }
}
