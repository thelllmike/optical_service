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
    int branchId =
        globals.branch_id; // Example of getting branchId from a global variable
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
          child: Column(
            children: [
              // Header row with padding and bold text style
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Customer Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Mobile Number', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Sales Person', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Lens Category', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Frame Brand', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Advance Paid', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Balance Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Pay Type', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              // Scrollable rows with padding
              Expanded(
                child: FutureBuilder<List<Invoice>>(
                  future: futureInvoices,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final invoice = snapshot.data![index];
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(child: Text(invoice.invoiceDate)),
                                Expanded(child: Text(invoice.customerName)),
                                Expanded(child: Text(invoice.mobileNumber)),
                                Expanded(child: Text(invoice.salesPerson)),
                                Expanded(child: Text(invoice.lensCategory)),
                                Expanded(child: Text(invoice.frameBrand)),
                                Expanded(child: Text('${invoice.advancePaid}')),
                                Expanded(child: Text('${invoice.grandTotal}')),
                                Expanded(child: Text('${invoice.balanceAmount}')),
                                Expanded(child: Text(invoice.payType)),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          // Implement edit action
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          // Implement delete action
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text("No data available"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}



}
