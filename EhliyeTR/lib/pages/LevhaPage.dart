import 'package:ehliyet_app/class/Levha.dart';
import 'package:ehliyet_app/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class LevhaPage extends StatefulWidget {
  Levha levha;
  LevhaPage(this.levha);
  @override
  _LevhaPageState createState() => _LevhaPageState();
}

class _LevhaPageState extends State<LevhaPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Levhalar",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF7c16c84),
              letterSpacing: 1.25),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 8,
              child: GestureDetector(
                  onTap: () {
                    if (_animationStatus == AnimationStatus.dismissed) {
                      // _animationController.forward();
                    } else {
                      // _animationController.reverse();
                    }
                  },
                  child: _animation.value <= 0.5
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(_animation.value * 3.14),
                          child: Container(
                            padding: EdgeInsets.all(1),
                            child: Container(
                                height: SizeConfig.safeBlockVertical * 80,
                                width: SizeConfig.safeBlockHorizontal * 90,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFF7c16c84), width: 2),
                                    color: Theme.of(context).cardColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(widget.levha.image),
                                    ),
                                  ),
                                )),
                          ),
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform:
                              Matrix4.rotationY(3.14 * (1 - _animation.value)),
                          child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                height: SizeConfig.safeBlockVertical * 80,
                                width: SizeConfig.safeBlockHorizontal * 90,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFF7c16c84), width: 2),
                                    color: Theme.of(context).cardColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Center(child: Text("Açıklamalar")),
                              )),
                        )),
            ),
            Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // RaisedButton(
                    //     color: Theme.of(context).cardColor,
                    //     child: Icon(Icons.timer),
                    //     onPressed: () {}),
                    RaisedButton(
                        color: Theme.of(context).cardColor,
                        child: Icon(Icons.check),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
