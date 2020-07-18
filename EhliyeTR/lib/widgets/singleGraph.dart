import 'package:ehliyet_app/blocs/theme.dart';
import 'package:ehliyet_app/utils/SizeConfig.dart';
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

class SingleGraphWidget extends StatefulWidget {
  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<SingleGraphWidget> {
  StatisticsDB sdb = StatisticsDB();
  List<charts.Series> overallWrong = [];
  List<charts.Series> overallTrue = [];
  List<DateTime> dateList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TestResult>>(
      future: sdb.getAllResults(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        if(snapshot.data.length == 0)
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                padding: EdgeInsets.all(56),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    )),
                child: Text("Grafikler İçin Test Çözmeniz Gerekir"),
                );
            
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
        }
        return Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    )),
                child: Column(
                  children: [
                    SizedBox(height: 6),
                    Text(
                      'Genel Performans',
                      style: TextStyle(
                          color: nicePink, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                        child: charts.BarChart(
                      [
                        charts.Series<ResultSeries, String>(
                            id: 'Yanlış',
                            colorFn: (ResultSeries res, _) =>
                                charts.Color.fromHex(code: "#d45656"),
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
                      behaviors: [
                        new charts.SeriesLegend(
                            showMeasures: true,
                            legendDefaultMeasure:
                                charts.LegendDefaultMeasure.average,
                            outsideJustification:
                                charts.OutsideJustification.endDrawArea,
                            entryTextStyle: charts.TextStyleSpec(
                                fontSize: 18,
                                color: charts.Color.fromHex(code: "#c16c84")))
                      ],
                      barGroupingType: charts.BarGroupingType.grouped,
                    )),
                  ],
                ),
              );
      },
    );
  }
}
