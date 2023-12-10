import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart'; // Make sure this import is correct

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ExpensesScreen(),
    );
  }
}

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _expenseAmountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _expenses = [];

  // Function to present DatePicker and pick a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addExpense() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _expenses.add({
          'name': _expenseNameController.text,
          'amount': _expenseAmountController.text,
          'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        });
        _expenseNameController.clear();
        _expenseAmountController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses Management'),
      ),
      body: Row(
        children: <Widget>[
          Sidebar(), // Ensure the Sidebar widget is correctly imported
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _expenseNameController,
                          decoration: InputDecoration(labelText: 'Expense Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an expense name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _expenseAmountController,
                          decoration: InputDecoration(labelText: 'Amount'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                            TextButton(
                              onPressed: () => _selectDate(context),
                              child: Text('Select Date'),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _addExpense,
                          child: Text('Add Expense'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Date')),
                        ],
                        rows: _expenses.map<DataRow>((expense) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(expense['name'])),
                              DataCell(Text(expense['amount'])),
                              DataCell(Text(expense['date'])),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
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


