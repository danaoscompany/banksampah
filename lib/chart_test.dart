import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:banksampah/global.dart';

class ChartTest extends StatefulWidget {
  @override
  State<StatefulWidget> creaChartTestate() => ChartTestState();
}

class ChartTestState extends State<ChartTest> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(color: Color(0xff939393), fontSize: 10),
                  margin: 1,
                  getTitles: (double value) {
                    return "Plastik";
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                      color: Color(
                        0xff939393,
                      ),
                      fontSize: 10),
                  margin: 0,
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 1 == 0,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: const Color(0xffe7e8ec),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              groupsSpace: 5,
              barGroups: getData(),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 10,
        barRods: [
          BarChartRodData(
              y: 1900,
              rodStackItems: [BarChartRodStackItem(0, 1900, Color(Global.mainColor))],
              borderRadius: const BorderRadius.all(Radius.zero))
        ],
      ),
      BarChartGroupData(
        x: 0,
        barsSpace: 10,
        barRods: [
          BarChartRodData(
              y: 5000,
              rodStackItems: [BarChartRodStackItem(0, 5000, Color(Global.mainColor))],
              borderRadius: const BorderRadius.all(Radius.zero))
        ],
      )
    ];
  }
}
