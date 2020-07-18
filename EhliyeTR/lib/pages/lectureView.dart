import 'package:ehliyet_app/blocs/theme.dart';
import 'package:ehliyet_app/pages/Levhalar.dart';
import 'package:ehliyet_app/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(24),
                  height: SizeConfig.safeBlockVertical * 20,
                  width: SizeConfig.safeBlockHorizontal * 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).cardColor,
                  ),
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.check_box,
                            size: SizeConfig.blockSizeHorizontal * 20),
                        Expanded(
                          child: Text(
                            "Levhalar",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 5,
                                color: Color(0xFF7c16c84),
                                fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    onTap: (){
                       Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LevhalarPage(),
                                  ));
                    }
                  ),
                )
              ])),
    );
  }
}
