import 'package:ehliyet_app/blocs/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flare_flutter/flare_actor.dart';

class LecturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Konu Anlatımı', style: TextStyle(color: nicePink),),
      ),
      body: Center(
        child: Text("Yakında :)",style: TextStyle(color: nicePink, fontWeight: FontWeight.w900)),
          // child: FlareActor("assets/Filip.flr",
          //     alignment: Alignment.center,
          //     fit: BoxFit.contain,
          //     animation: "idle")
              ),
    );
  }
}
