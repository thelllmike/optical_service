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
          Sidebar(), // Ensure Sidebar widget is properly defined in sidebar.dart
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
                    PieChartSectionData(value: 40, color: Colors.red, title: '40%', showTitle: true),
                    PieChartSectionData(value: 30, color: Colors.green, title: '30%', showTitle: true),
                    PieChartSectionData(value: 30, color: Colors.blue, title: '30%', showTitle: true),
                  ],
                  sectionsSpace: 0, // No space between sections
                  centerSpaceRadius: 40, // Radius of the center space inside pie chart
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
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      margin: 16,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Jan';
                          case 1:
                            return 'Feb';
                          case 2:
                            return 'Mar';
                          // Continue for other months
                          default:
                            return '';
                        }
                      },
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
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          y: 10,
                          colors: [Colors.lightGreenAccent, Colors.greenAccent],
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          y: 14,
                          colors: [Colors.orangeAccent, Colors.deepOrange],
                          width: 20,
                        ),
                      ],
                    ),
                    // Add more BarChartGroupData for other months if needed
                  ],
                ),
              ),
            ),
            // Add additional dashboard widgets here if needed
          ],
        ),
      ),
    );
  }
}
