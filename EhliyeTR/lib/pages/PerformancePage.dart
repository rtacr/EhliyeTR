import 'package:ehliyet_app/blocs/theme.dart';
import 'package:ehliyet_app/utils/constantValues.dart';
import 'package:ehliyet_app/utils/dbUtils.dart';
import 'package:flutter/material.dart';
import 'package:ehliyet_app/class/testResult.dart';
import 'package:charts_flutter/flutter.dart' as charts;



///Series class for the chart
class ResultSeries {
  final int count;
  final int date;
  final Color color;

  ResultSeries({this.count, this.date, this.color});
}

class PerformancePage extends StatefulWidget {
  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  StatisticsDB sdb = StatisticsDB();
  List<charts.Series> overallWrong = [];
  List<charts.Series> overallTrue = [];
  List<DateTime> dateList = [];
  BoxDecoration bd = BoxDecoration(
    color: Color.fromRGBO(30, 30, 30, 1),
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      // BoxShadow(
      //     color: Colors.black,
      //     offset: Offset(4.0, 4.0),
      //     blurRadius: 8.0,
      //     spreadRadius: 0.2),
      // BoxShadow(
      //     color: Colors.grey[800],
      //     offset: Offset(-4.0, -4.0),
      //     blurRadius: 8.0,
      //     spreadRadius: 0.2),
    ],
  );

  var behs = [new charts.SeriesLegend(
                        showMeasures: true,
                        legendDefaultMeasure: charts.LegendDefaultMeasure.average,
                        outsideJustification: charts.OutsideJustification.endDrawArea,
                        entryTextStyle: charts.TextStyleSpec(
                          fontSize: 18,
                          color: charts.Color.fromHex(code: "#c16c84")))];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Analizlerim", style: TextStyle(color: nicePink)),
          centerTitle: true,
          elevation: 0),
      body: FutureBuilder<List<TestResult>>(
          future: sdb.getAllResults(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            overallWrong = [];
            overallTrue = [];
            dateList = [];
            TestResult overallTr = TestResult().cleanResult();
            for (int i = 0; i < snapshot.data.length; i++) {
              overallTr.questionCount += snapshot.data[i].questionCount;
              overallTr.falseCount += snapshot.data[i].falseCount;
              overallTr.t1True += snapshot.data[i].t1True;
              overallTr.t1False += snapshot.data[i].t1False;
              overallTr.t2True += snapshot.data[i].t2True;
              overallTr.t2False += snapshot.data[i].t2False;
              overallTr.t3True += snapshot.data[i].t3True;
              overallTr.t3False += snapshot.data[i].t3False;
              dateList.add(DateTime.parse(snapshot.data[i].dateTime));
              // overallWrong.add(DataPoint(
              //     value: (snapshot.data[i].falseCount) * 1.0,
              //     xAxis: dateList[i]));
              // overallTrue.add(DataPoint(
              //     value: (snapshot.data[i].questionCount -
              //             snapshot.data[i].falseCount) *
              //         1.0,
              //     xAxis: dateList[i]));
            }
            return ListView(children: [
              
              SizedBox(height: 24),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                height: MediaQuery.of(context).size.height / 3,
                decoration: bd.copyWith(color: Theme.of(context).cardColor),
                child: Column(
                  children: [
                    SizedBox(height: 6),
                    Text('Genel Performans', style: TextStyle(color: nicePink)),
                    Expanded(
                        child: charts.BarChart(
                      [
                        charts.Series<ResultSeries, String>(
                            id: 'Yanlış',
                            colorFn: (ResultSeries res, _) =>
                                charts.Color.fromHex(code: "#f7b186"),
                            domainFn: (ResultSeries res, _) =>
                                TestResult().dtFormat(dateList[res.date]),
                            measureFn: (ResultSeries res, _) => res.count,
                            data: List.generate(snapshot.data.length, (index) {
                              return ResultSeries(
                                  count: snapshot.data[index].falseCount,
                                  date: index,
                                  color: Colors.green);
                            })),
                        charts.Series<ResultSeries, String>(
                            id: 'Doğru',
                            colorFn: (ResultSeries res, _) =>
                                charts.Color.fromHex(code: "#7FAA98"),
                            domainFn: (ResultSeries res, _) =>
                                TestResult().dtFormat(dateList[res.date]),
                            measureFn: (ResultSeries res, _) => res.count,
                            data: List.generate(snapshot.data.length, (index) {
                              return ResultSeries(
                                  count: snapshot.data[index].questionCount -
                                      snapshot.data[index].falseCount,
                                  date: index,
                                  color: Colors.green);
                            })),
                      ],
                      behaviors: behs,
                      barGroupingType: charts.BarGroupingType.grouped,
                    )),
                  ]
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                height: MediaQuery.of(context).size.height / 3,
                decoration: bd.copyWith(color: Theme.of(context).cardColor),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 6),
                    Text(topic1, style: TextStyle(color: nicePink)),
                    SizedBox(height: 6),
                    Expanded(
                        child: charts.BarChart(
                      [
                        charts.Series<ResultSeries, String>(

                            // TestResult().dtFormat(dateList[date]),
                            id: 'Yanlış',
                            colorFn: (ResultSeries res, _) =>
                                charts.Color.fromHex(code: "#f7b186"),
                            domainFn: (ResultSeries res, _) =>
                                TestResult().dtFormat(dateList[res.date]),
                            measureFn: (ResultSeries res, _) => res.count,
                            data: List.generate(snapshot.data.length, (index) {
                              return ResultSeries(
                                  count: snapshot.data[index].t1False,
                                  date: index,
                                  color: Colors.green);
                            })),
                        charts.Series<ResultSeries, String>(
                            id: 'Doğru',
                            colorFn: (ResultSeries res, _) =>
                                charts.Color.fromHex(code: "#7FAA98"),
                            domainFn: (ResultSeries res, _) =>
                                TestResult().dtFormat(dateList[res.date]),
                            measureFn: (ResultSeries res, _) => res.count,
                            data: List.generate(snapshot.data.length, (index) {
                              return ResultSeries(
                                  count: snapshot.data[index].t1True,
                                  date: index,
                                  color: Colors.green);
                            })),
                      ],
                      behaviors: behs,
                      barGroupingType: charts.BarGroupingType.grouped,
                      animate: true,
                    )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                height: MediaQuery.of(context).size.height / 3,
                decoration: bd.copyWith(color: Theme.of(context).cardColor),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 6),
                    Text(topic2, style: TextStyle(color: nicePink)),
                    SizedBox(height: 6),
                    Expanded(
                        child: charts.BarChart(
                      [
                        charts.Series<ResultSeries, String>(

                            // TestResult().dtFormat(dateList[date]),
                            id: 'Yanlış',
                            colorFn: (ResultSeries res, _) =>
                                charts.Color.fromHex(code: "#f7b186"),
                            domainFn: (ResultSeries res, _) =>
                                TestResult().dtFormat(dateList[res.date]),
                            measureFn: (ResultSeries res, _) => res.count,
                            data: List.generate(snapshot.data.length, (index) {
                              return ResultSeries(
                                  count: snapshot.data[index].t2False,
                                  date: index,
                                  color: Colors.green);
                            })),
                        charts.Series<ResultSeries, String>(
                            id: 'Doğru',
                            colorFn: (ResultSeries res, _) =>
                                charts.Color.fromHex(code: "#7FAA98"),
                            domainFn: (ResultSeries res, _) =>
                                TestResult().dtFormat(dateList[res.date]),
                            measureFn: (ResultSeries res, _) => res.count,
                            data: List.generate(snapshot.data.length, (index) {
                              return ResultSeries(
                                  count: snapshot.data[index].t2True,
                                  date: index,
                                  color: Colors.green);
                            })),
                      ],
                      barGroupingType: charts.BarGroupingType.grouped,
                      behaviors: behs,
                      animate: true,
                    )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                height: MediaQuery.of(context).size.height / 3,
                decoration: bd.copyWith(color: Theme.of(context).cardColor),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 6),
                    Text(topic3, style: TextStyle(color: nicePink)),
                    SizedBox(height: 6),
                    Expanded(
                        child: charts.BarChart(
                      [
                        charts.Series<ResultSeries, String>(

                            // TestResult().dtFormat(dateList[date]),
                            id: 'Yanlış',
                            colorFn: (ResultSeries res, _) =>
                                charts.Color.fromHex(code: "#f7b186"),
                            domainFn: (ResultSeries res, _) =>
                                TestResult().dtFormat(dateList[res.date]),
                            measureFn: (ResultSeries res, _) => res.count,
                            data: List.generate(snapshot.data.length, (index) {
                              return ResultSeries(
                                  count: snapshot.data[index].t3False,
                                  date: index,
                                  color: Colors.green);
                            })),
                        charts.Series<ResultSeries, String>(
                            id: 'Doğru',
                            colorFn: (ResultSeries res, _) =>
                                charts.Color.fromHex(code: "#7FAA98"),
                            domainFn: (ResultSeries res, _) =>
                                TestResult().dtFormat(dateList[res.date]),
                            measureFn: (ResultSeries res, _) => res.count,
                            data: List.generate(snapshot.data.length, (index) {
                              return ResultSeries(
                                  count: snapshot.data[index].t3True,
                                  date: index,
                                  color: Colors.green);
                            })),
                      ],
                      barGroupingType: charts.BarGroupingType.grouped,
                      behaviors: behs,
                      animate: true,
                    )),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 8)
            ]);
          }),
    );
  }
}
