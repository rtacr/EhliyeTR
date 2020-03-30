import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  bool _darkMode;
  ThemeChanger(this._themeData, this._darkMode);

  getTheme() => _themeData;

  getDark() => _darkMode;

  writePrefs(bool dt) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("ehliyapp_darkTheme", dt);
  }

  setTheme(ThemeData theme, bool darkMode) {
    _themeData = theme;
    _darkMode = darkMode;
    writePrefs(darkMode);
    notifyListeners();
  }
}

Map<int, Color> twitterBlue = {
  50:  Color.fromRGBO(187, 221, 198, .1),
  100: Color.fromRGBO(187, 221, 198, .2),
  200: Color.fromRGBO(187, 221, 198, .3),
  300: Color.fromRGBO(187, 221, 198, .4),
  400: Color.fromRGBO(187, 221, 198, .5),
  500: Color.fromRGBO(187, 221, 198, .6),
  600: Color.fromRGBO(187, 221, 198, .7),
  700: Color.fromRGBO(187, 221, 198, .8),
  800: Color.fromRGBO(187, 221, 198, .9),
  900: Color.fromRGBO(187, 221, 198, 1), 
};
ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xFF344951),
  backgroundColor: Color(0xFF344951),
  dialogBackgroundColor: Color(0xFF344951),
  canvasColor: Color.fromRGBO(30, 30, 30, 1),
  iconTheme: IconThemeData(
    color: Color(0xFF344951)
  ),
  fontFamily: "SuezOne",
    cardColor: Color(0xffbbddc6),
  buttonColor: Color(0xFFf8f1d6),
  textTheme: TextTheme(
      body1: TextStyle(fontSize: 24, color: Colors.white, letterSpacing: 1.25),
      subhead:
          TextStyle(fontSize: 18, color: Colors.white, letterSpacing: 1.10)),
  primarySwatch: MaterialColor(0xFF344951, twitterBlue),
);

Map<int, Color> color = {
  50:  Color.fromRGBO(187, 221, 198, .1),
  100: Color.fromRGBO(187, 221, 198, .2),
  200: Color.fromRGBO(187, 221, 198, .3),
  300: Color.fromRGBO(187, 221, 198, .4),
  400: Color.fromRGBO(187, 221, 198, .5),
  500: Color.fromRGBO(187, 221, 198, .6),
  600: Color.fromRGBO(187, 221, 198, .7),
  700: Color.fromRGBO(187, 221, 198, .8),
  800: Color.fromRGBO(187, 221, 198, .9),
  900: Color.fromRGBO(187, 221, 198, 1),
};

ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0XFFf8f1d6 ),
    backgroundColor: Colors.white,
    dialogBackgroundColor: Color.fromRGBO(100, 100, 100, 1),
    canvasColor: Color.fromRGBO(1, 30, 30, 1),
    fontFamily: "SuezOne",
  buttonColor: Color(0xFFf8f1d6),
    iconTheme: IconThemeData(
      color: Color(0xFF7faa98)
    ),
    cardColor: Color(0xffbbddc6),
    textTheme: TextTheme(
        body1:
            TextStyle(fontSize: 24, color: Colors.black, letterSpacing: 1.25),
        subhead:
            TextStyle(fontSize: 18, color: Colors.black, letterSpacing: 1.10)),
    //primarySwatch: MaterialColor(0xFFC8963C ,color)
    primarySwatch: MaterialColor(0xFFf8f1d6, color));

Color nicePink = Color(0xFF7c16c84);