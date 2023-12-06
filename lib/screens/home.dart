import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart';



final ValueNotifier<ThemeData> _themeNotifier = ValueNotifier(ThemeData.dark());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: _themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Homescreen(),
        );
      },
    );
  }
}

class Homescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Row(
        children: <Widget>[
          Sidebar(), // Use the Sidebar widget from sidebar.dart
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: ChartsWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 200,
          width: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(value: 40, color: Colors.red, title: 'Red'),
                PieChartSectionData(value: 30, color: Colors.blue, title: 'Blue'),
                PieChartSectionData(value: 30, color: Colors.green, title: 'Green'),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 200,
          width: 300,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(showTitles: true),
                leftTitles: SideTitles(showTitles: true),
              ),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [BarChartRodData(y: 8, width: 15)]),
                BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 10, width: 15)]),
                BarChartGroupData(x: 2, barRods: [BarChartRodData(y: 14, width: 15)]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
