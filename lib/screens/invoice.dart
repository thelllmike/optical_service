import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this line to format dates


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

  // Function to present DatePicker and pick a date
Future<void> _selectDate(BuildContext context, bool isStart) async {
  DateTime initialDate = isStart ? selectedStartDate : selectedEndDate;
  DateTime firstDate = DateTime(2000);
  DateTime lastDate = DateTime(2101);

  // Ensure that the initialDate is within the range between firstDate and lastDate
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ),
          Expanded(
            child: SingleChildScrollView(
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
          ),
          ElevatedButton(
            onPressed: () {
              // Implement generate invoice logic
            },
            child: Text('Generate Invoice'),
          ),
        ],
      ),
    );
  }
}
