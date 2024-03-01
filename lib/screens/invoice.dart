import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optical_desktop/requesthadleing/invoice.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart'; // Ensure this path is correct
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optical_desktop/global.dart' as globals;

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
    Future<List<Invoice>>? futureInvoices; // Declare futureInvoices here

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
  void initState() {
    super.initState();
     int branchId = globals.branch_id; // Example of getting branchId from a global variable
  futureInvoices = fetchInvoices(branchId);
  }
///Quary/billing-details
Future<List<Invoice>> fetchInvoices(int branchId) async {
  final uri = Uri.parse('http://localhost:8001/Quary/billing-details')
      .replace(queryParameters: {'branch_id': branchId.toString()});
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Invoice.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load invoices for branch ID $branchId');
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
          Sidebar(),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Date selection and search button...

                  FutureBuilder<List<Invoice>>(
                    future: futureInvoices,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return Expanded(
                          child:DataTable(
  columns: const <DataColumn>[
    DataColumn(label: Text('Date')),
    DataColumn(label: Text('Customer Name')),
    DataColumn(label: Text('Mobile Number')),
    DataColumn(label: Text('Sales Person')),
    DataColumn(label: Text('Lens Category')),
    DataColumn(label: Text('Frame Brand')),
    DataColumn(label: Text('Advance Paid')),
    DataColumn(label: Text('Grand Total')),
    DataColumn(label: Text('Balance Amount')),
    DataColumn(label: Text('Pay Type')),
    DataColumn(label: Text('Action')), // This column is for your actions like edit/delete
  ],
   rows: snapshot.data!.map<DataRow>((invoice) => DataRow(
  cells: <DataCell>[
    DataCell(Text(invoice.invoiceDate)),
    DataCell(Text(invoice.customerName)),
    DataCell(Text(invoice.mobileNumber)),
    DataCell(Text(invoice.salesPerson)),
    DataCell(Text(invoice.lensCategory)),
    DataCell(Text(invoice.frameBrand)),
    DataCell(Text('${invoice.advancePaid}')), // Assuming advancePaid is a numeric type
    DataCell(Text('${invoice.grandTotal}')),  // Assuming grandTotal is a numeric type
    DataCell(Text('${invoice.balanceAmount}')), // Assuming balanceAmount is a numeric type
    DataCell(Text(invoice.payType)),
    DataCell(Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            // TODO: Implement your edit action
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            // TODO: Implement your delete action
          },
        ),
      ],
    )), // Action buttons for each row
  ],
)).toList(),

                          ),
                        );
                      }
                    },
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