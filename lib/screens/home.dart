import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart';
import 'package:optical_desktop/global.dart'as globals; // Make sure this import is correct

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeData> _themeNotifier =
      ValueNotifier(ThemeData.dark());

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


class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
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
              // The default scrollDirection is vertical.
              child: Column(
                children: [
                  SummaryCards(),
                  ChartsWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class SummaryCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SummaryCard(title: 'Monthly Sales', value: '4', color: Colors.orange),
        SummaryCard(title: 'today Orders', value: '47', color: Colors.green),
        SummaryCard(title: 'Today Sales', value: '2', color: Colors.pink),
        SummaryCard(title: 'Today Customers', value: '923', color: Colors.blue),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const SummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}



class Legend extends StatelessWidget {
  final Color color;
  final String text;

  const Legend({Key? key, required this.color, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, color: color),
        SizedBox(width: 8.0),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}






class ChartsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      // Center the content
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sales Distribution',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                        value: 40,
                        color: Colors.red,
                        title: '40%',
                        showTitle: true),
                    PieChartSectionData(
                        value: 30,
                        color: Colors.green,
                        title: '30%',
                        showTitle: true),
                    PieChartSectionData(
                        value: 30,
                        color: Colors.blue,
                        title: '30%',
                        showTitle: true),
                  ],
                  sectionsSpace: 0, // No space between sections
                  centerSpaceRadius:
                      40, // Radius of the center space inside pie chart
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Monthly Sales',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  maxY: 20,
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      margin: 8,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Jan';
                          case 1:
                            return 'Feb';
                          case 2:
                            return 'Mar';
                          case 3:
                            return 'Apr';
                          case 4:
                            return 'May';
                          case 5:
                            return 'Jun';  
                          case 6:
                            return 'Jul';  
                          case 7:
                            return 'Aug';
                           case 8:
                            return 'Sep';
                          case 9:
                            return 'Oct';
                          case 10:
                            return 'Nov';
                          case 11:
                            return 'Dec';
                       
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
                        BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          y: 20,
                          colors: [Colors.orangeAccent, Colors.deepOrange],
                          width: 20,
                        ),
                      ],
                    ),
                        BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          y: 25,
                          colors: [Color.fromARGB(255, 153, 199, 53), Colors.deepOrange],
                          width: 20,
                        ),
                      ],
                    ),
                        BarChartGroupData(
                      x: 5,
                      barRods: [
                        BarChartRodData(
                          y: 04,
                          colors: [Color.fromARGB(255, 32, 120, 12), Colors.deepOrange],
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 6,
                      barRods: [
                        BarChartRodData(
                          y: 10,
                          colors: [Color.fromARGB(255, 6, 152, 132), Colors.deepOrange],
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 7,
                      barRods: [
                        BarChartRodData(
                          y: 14,
                          colors: [Color.fromARGB(255, 7, 62, 134), Colors.deepOrange],
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 8,
                      barRods: [
                        BarChartRodData(
                          y: 44,
                          colors: [Color.fromARGB(255, 129, 60, 218), Colors.deepOrange],
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 9,
                      barRods: [
                        BarChartRodData(
                          y: 34,
                          colors: [Color.fromARGB(255, 167, 24, 183), Colors.deepOrange],
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 10,
                      barRods: [
                        BarChartRodData(
                          y: 4,
                          colors: [Color.fromARGB(255, 68, 60, 126), Colors.deepOrange],
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 11,
                      barRods: [
                        BarChartRodData(
                          y: 14,
                          colors: [Color.fromARGB(255, 179, 24, 81), Colors.deepOrange],
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