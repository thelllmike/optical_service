import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: BillScreen(),
    );
  }
}

class BillScreen extends StatefulWidget {
  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  bool _isDarkMode = false;
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vision Express Optical Service'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _buildCustomerDetailsSection()),
                  Expanded(child: _buildFrameDetailsSection()),
                  Expanded(child: _buildInvoiceAndDeliveryDetailsSection()),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildLensDetailsSection()),
                  Expanded(child: _buildPrescriptionDetailsSection()),
                  Expanded(child: _buildPaymentDetailsSection()),
                ],
              ),
              SizedBox(height: 16),
              _buildSaveAndPrintButton(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle save & print logic here
        },
        child: Icon(Icons.print),
        tooltip: 'Save & Print (F12)',
      ),
    );
  }

  Widget _buildCustomerDetailsSection() {
    return _buildDetailsCard('Customer Details', [
      _buildDropdownField('Mobile Number', ['1234567890', '9876543210']),
      _buildTextField('Full Name'),
      _buildTextField('NIC Number'),
      _buildTextField('Address', maxLines: 3),
      _buildDropdownField('Gender', ['Male', 'Female', 'Other']),
    ]);
  }

  Widget _buildFrameDetailsSection() {
    return _buildDetailsCard('Frame Details', [
      _buildDropdownField('Frame', ['Frame1', 'Frame2']),
      _buildDropdownField('Brand', ['Brand1', 'Brand2']),
      _buildTextField('Model'),
      _buildTextField('Size'),
      _buildTextField('Color'),
      _buildTextField('Frame Stock'),
      _buildTextField('Selling'),
    ]);
  }

  Widget _buildInvoiceAndDeliveryDetailsSection() {
    return _buildDetailsCard('Invoice & Delivery Details', [
      _buildDatePickerField('Invoice Date'),
      _buildDatePickerField('Delivery Date'),
      _buildDropdownField('Sales Person', ['Person1', 'Person2']),
    ]);
  }

  Widget _buildLensDetailsSection() {
    return _buildDetailsCard('Lens Details', [
      _buildDropdownField('Lens Category', ['Category1', 'Category2']),
      _buildTextField('Coating'),
      _buildTextField('Lens Stock'),
      _buildTextField('Selling'),
    ]);
  }

  Widget _buildPrescriptionDetailsSection() {
    return _buildDetailsCard('Prescription Details', [
      _buildTextField('Type'),
      _buildTextField('SH'),
      _buildTextField('SPH'),
      _buildTextField('CYL'),
      _buildTextField('AXIS'),
      _buildTextField('ADD'),
    ]);
  }

  Widget _buildPaymentDetailsSection() {
    return _buildDetailsCard('Payment Details', [
      _buildTextField('Total Amount'),
      _buildTextField('Discount'),
      _buildTextField('Fitting Charges'),
      _buildTextField('Grand Total'),
      _buildTextField('Advance Paid'),
      _buildTextField('Balance Amount'),
      _buildDropdownField('Pay Type', ['Cash', 'Card']),
      _buildDropdownField('Account', ['Account1', 'Account2']),
    ]);
  }

  Widget _buildSaveAndPrintButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle save & print logic here
        },
        child: Text('Save & Print (F12)'),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {},
      ),
    );
  }

  Widget _buildDatePickerField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: _selectedDate.toLocal().toString().split(' ')[0]),
          ),
        ),
      ),
    );
  }
}
