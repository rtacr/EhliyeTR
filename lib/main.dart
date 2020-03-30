import 'package:ehliyet_app/blocs/theme.dart';
import 'package:ehliyet_app/class/exam.dart';
import 'package:ehliyet_app/pages/AdminControls.dart';
import 'package:ehliyet_app/pages/CardyExamPage.dart';
import 'package:ehliyet_app/pages/PerformancePage.dart';
import 'package:ehliyet_app/pages/lectureView.dart';
import 'package:ehliyet_app/utils/fetchQuestions.dart';
import 'package:ehliyet_app/widgets/singleGraph.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  exam();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData _temp;
    return FutureBuilder(
      future: loadFromSP(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        if (snapshot.data) {
          _temp = darkTheme;
        } else {
          _temp = lightTheme;
        }
        return MultiProvider(providers: [
          ChangeNotifierProvider(
              create: (context) => ThemeChanger(_temp, false))
        ], child: MApp());
      },
    );
  }

  Future<bool> loadFromSP() async {
    String keyDt = "ehliyapp_darkTheme";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool empty = prefs.containsKey(keyDt);
    if (!empty) {
      await prefs.setBool(keyDt, false);
    }
    return prefs.getBool(keyDt);
  }
}

class MApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _theme.getTheme(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd _bannerAd;
  String admobID = "ca-app-pub-4262806235664188~1212727631";
  InterstitialAd _intAd;

  BannerAd createBanner() {
    return BannerAd(
      adUnitId: "ca-app-pub-4262806235664188/5018883346",
      size: AdSize.banner,
      listener: (event) {
        print("Ad $event");
      },
    );
  }

  InterstitialAd createIntAd() {
    return InterstitialAd(
        adUnitId: "ca-app-pub-4262806235664188/2201148310",
        listener: (event) {
          print("Int Ad $event");
        });
  }

  hideBanner() {
    setState(() {
      _bannerAd.dispose();
    });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: admobID);
    _bannerAd = createBanner();
    _bannerAd.load();
    _bannerAd.show();
    super.initState();
  }

  @override
  void dispose() {
    // _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'EhliyeTR',
          style: TextStyle(
              letterSpacing: 4,
              color: Color(0xFF7c16c84),
              fontWeight: FontWeight.w900),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb_outline),
            onPressed: () {
              final currentTheme = _themeChanger.getTheme();
              if (currentTheme == darkTheme)
                _themeChanger.setTheme(lightTheme, false);
              else
                _themeChanger.setTheme(darkTheme, true);
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          Flexible(flex: 3, child: SingleGraphWidget()),
          Flexible(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 4.5,
                          width: MediaQuery.of(context).size.width / 2.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Theme.of(context).cardColor,
                          ),
                          child: InkWell(
                            child: Column(
                              children: [
                                Icon(Icons.check_box, size: 100),
                                Expanded(
                                  child: Text(
                                    "Konu Anlatımı",
                                    style: TextStyle(
                                        color: Color(0xFF7c16c84),
                                        fontWeight: FontWeight.w900),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LecturePage(),
                                  ));
                            },
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 4.5,
                          width: MediaQuery.of(context).size.width / 2.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Theme.of(context).cardColor,
                          ),
                          child: InkWell(
                            child: Column(
                              children: [
                                Icon(Icons.show_chart, size: 120),
                                Text(
                                  "Analiz",
                                  style: TextStyle(
                                      color: Color(0xFF7c16c84),
                                      fontWeight: FontWeight.w900),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            onTap: () {
                              hideBanner();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WillPopScope(
                                        onWillPop: () {
                                          Navigator.pop(context);
                                          _bannerAd = createBanner()
                                            ..load()
                                            ..show();
                                          return Future.value(true);
                                        },
                                        child: PerformancePage()),
                                  ));
                            },
                          ),
                        ),
                      ]),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).cardColor,
                  ),
                  width: MediaQuery.of(context).size.width / 2,
                  child: InkWell(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.book, size: 120),
                          Text(
                            "Deneme Çöz",
                            style: TextStyle(
                                color: Color(0xFF7c16c84),
                                fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                    onTap: () {
                      hideBanner();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WillPopScope(
                              onWillPop: () {
                                _intAd = createIntAd()
                                  ..load()
                                  ..show();
                                _bannerAd = createBanner()
                                  ..load()
                                  ..show();
                                Navigator.pop(context);
                                return Future.value(true);
                              },
                              child: FutureBuilder<Exam>(
                                  future: Exam().createExam(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return Center(
                                          child: CircularProgressIndicator());
                                    return CardyExamPage_State(snapshot.data);
                                  }),
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
          Flexible(flex: 1, child: Container()), // for ad and stuff
        ]),
      ),
    );
  }
}
