import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart'; // Ensure this path is correct


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: InvoiceScreen(),
    );
  }
}

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime initialDate = isStart ? selectedStartDate : selectedEndDate;
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }
    if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        if (isStart) {
          selectedStartDate = picked;
        } else {
          selectedEndDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Optical Sales Invoice Screen'),
      ),
      body: Row(
        children: <Widget>[
          Sidebar(), // Sidebar widget
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, true),
                          child: Text('Start Date: ${DateFormat('yyyy-MM-dd').format(selectedStartDate)}'),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: Text('End Date: ${DateFormat('yyyy-MM-dd').format(selectedEndDate)}'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement search logic
                        },
                        child: Text('Search'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Mobile Number')),
                        DataColumn(label: Text('Customer Name')),
                        DataColumn(label: Text('Advance')),
                        DataColumn(label: Text('Lens Cost')),
                        DataColumn(label: Text('Frame Cost')),
                        DataColumn(label: Text('Total')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: const <DataRow>[
                        // Populate data rows with actual data
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement generate invoice logic
                    },
                    child: Text('Generate Invoice'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
