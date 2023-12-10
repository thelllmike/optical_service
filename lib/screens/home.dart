import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart'; // Make sure this import is correct

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeData> _themeNotifier = ValueNotifier(ThemeData.dark());

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
          Sidebar(), // Sidebar widget, make sure you have this in your project
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: SingleChildScrollView(
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
    return Center( // Center the content
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sales Distribution',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(value: 40, color: Colors.red, title: '40%'),
                    PieChartSectionData(value: 30, color: Colors.green, title: '30%'),
                    PieChartSectionData(value: 30, color: Colors.blue, title: '30%'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Monthly Sales',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(
  height: 200,
  child: BarChart(
    BarChartData(
      alignment: BarChartAlignment.spaceAround, // Adjusts the spacing around bars
      maxY: 20,
      barTouchData: BarTouchData(
        enabled: false, // Disable touch interactions
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
        ),
        leftTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(show: false),
      barGroups: [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              y: 8,
              colors: [Colors.lightBlueAccent, Colors.blueAccent],
              width: 20, // Adjust the bar width
            ),
          ],
        ),
        // ... Add other bar groups here
      ],
    ),
  ),
),

            // Add additional dashboard widgets here
          ],
        ),
      ),
    );
  }
}
