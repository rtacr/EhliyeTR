import 'package:ehliyet_app/utils/dbUtils.dart';
import 'package:flutter/material.dart';

class AdminControls extends StatefulWidget {
  @override
  _AdminControlsState createState() => _AdminControlsState();
}

class _AdminControlsState extends State<AdminControls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Admin Controls")),
      body: Container(
        child: GridView(
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            children: [
              InkWell(child: Text("Destroy Database"),
                onTap: (){
                  DatabaseUtils db = DatabaseUtils();
                  db.destroyDatabase();
                  setState(() {
                    print("Destroyed");
                  });
                },
              ),
              FutureBuilder<int>(
                future: DatabaseUtils().questionCount(),
                builder: (context, snapshot) {
                  return Container(
                    child: Text("Database Entry : ${snapshot.data}")
                  );
                }
              ), 
              InkWell(child: Text("Destroy Stat Database"),
                onTap: () async{
                  StatisticsDB db = StatisticsDB();
                  await db.deleteContent();
                  setState(() {
                    print("Destroyed");
                  });
                },
              ),
              FutureBuilder<int>(
                future: StatisticsDB().questionCount(),
                builder: (context, snapshot) {
                  return Container(
                    child: Text("Stat Database Entry : ${snapshot.data}")
                  );
                }
              )


            ]),
      ),
    );
  }
}
