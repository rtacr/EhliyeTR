import 'package:ehliyet_app/blocs/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturePage extends StatefulWidget {
  @override
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  String animationValue;

  @override
  void initState() {
    animationValue = "idle";
    super.initState();
  }
  loadTheme ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool("ehliyapp_darkTheme");
    if(isDark){
      animationValue = "LightToDark";
    }else{
      animationValue = "DarkToLight";
    }
  }
  @override
  Widget build(BuildContext context) {
    final _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Konu Anlatımı',
          style: TextStyle(color: nicePink),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb_outline),
            onPressed: () {
              final currentTheme = _themeChanger.getTheme();
              if (currentTheme == darkTheme) {
                _themeChanger.setTheme(lightTheme, false);
                setState(() {
                  animationValue = "DarkToLight";
                });
              } else {
                _themeChanger.setTheme(darkTheme, true);
                setState(() {
                  animationValue = "LightToDark";
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadTheme(),
        builder: (context, snapshot) {
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: MediaQuery.of(context).size.height,
              child: //Text("Yakında :)",style: TextStyle(color: nicePink, fontWeight: FontWeight.w900)),
                  Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height / 15),
                      Text("Yakında Hazır", style: TextStyle(color: nicePink)),
                      Expanded(
                        child: FlareActor("assets/Yakında.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.fitWidth,
                            animation: animationValue),
                      ),
                    ],
                  ));
        }
      ),
    );
  }
}
