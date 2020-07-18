import 'package:ehliyet_app/blocs/theme.dart';
import 'package:ehliyet_app/class/Levha.dart';
import 'package:ehliyet_app/pages/LevhaPage.dart';
import 'package:flutter/material.dart';


class LevhalarPage extends StatefulWidget {
  @override
  _LevhalarPageState createState() => _LevhalarPageState();
}

class _LevhalarPageState extends State<LevhalarPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  var bilgiList = [];
  var uyariList = [];
  var tanzimList = [];
  
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    bilgiList = List<Levha>.generate(
        76, (index) => Levha(image: "assets/Levhalar/0-$index.png"));
        
    uyariList = List<Levha>.generate(
        50, (index) => Levha(image: "assets/Levhalar/1-$index.png"));
        
    tanzimList = List<Levha>.generate(
        63, (index) => Levha(image: "assets/Levhalar/0-$index.png"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Trafik Levhaları',
          style: TextStyle(color: nicePink),
        ),
        bottom: TabBar(controller: _tabController, tabs: [
          Text("Bilgi İşaretleri",
              style: TextStyle(color: nicePink, fontSize: 14)),
          Text("Trafik Tanzim İşaretleri",
              style: TextStyle(color: nicePink, fontSize: 14)),
          Text("Tehlikeli Uyarı İşaretleri",
              style: TextStyle(color: nicePink, fontSize: 14)),
        ]),
      ),
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.75,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    crossAxisCount: 2),
                children: bilgiList
                    .map(
                      (e) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Theme.of(context).cardColor),
                            padding: EdgeInsets.all(24),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(e.image),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LevhaPage(e),
                                  ));
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.75,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    crossAxisCount: 2),
                children: uyariList
                    .map(
                      (e) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).cardColor,
                          image: DecorationImage(
                            image: AssetImage(e.image),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LevhaPage(e),
                                ));
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.75,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    crossAxisCount: 2),
                children: tanzimList
                    .map(
                      (e) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).cardColor,
                          image: DecorationImage(
                            image: AssetImage(e.image),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LevhaPage(e),
                                ));
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
