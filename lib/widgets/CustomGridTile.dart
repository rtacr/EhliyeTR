import 'package:flutter/material.dart';

class CustomGridTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final IconData icon;

  CustomGridTile({this.onTap, this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            // BoxShadow(
            //     color: Colors.black,
            //     offset: Offset(4.0, 4.0),
            //     blurRadius: 20,
            //     spreadRadius: 0.5),
            // BoxShadow(
            //     color: Theme.of(context).accentColor,
            //     offset: Offset(-4.0, -4.0),
            //     blurRadius: 15,
            //     spreadRadius: 0.5),
          ],
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        child: InkWell(
          onTap: onTap,
          child: Container(
            child: Icon(
              icon,
              color: Colors.white,
              size: 125,
            ),
          ),
          // title: Center(
          //   child: Text(
          //     title,
          //     style: TextStyle(color: Colors.white, fontSize: 28),
          //   ),
          // ),
        ),
      ),
    );
  }
}
