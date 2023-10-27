import 'package:flutter/material.dart';



class BillScreen extends StatefulWidget {
  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vision Express Optical Service'),
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDetailsCard('Customer Details', [
                _buildTextField('Mobile Number'),
                _buildTextField('Full Name'),
                _buildTextField('NIC Number'),
                _buildTextField('Address'),
                _buildTextField('Gender'),
              ]),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailsCard('Frame Details', [
                      _buildTextField('Frame'),
                      _buildTextField('Brand'),
                      _buildTextField('Model'),
                      _buildTextField('Size'),
                      _buildTextField('Color'),
                      _buildTextField('Frame Stock'),
                      _buildTextField('Selling'),
                    ]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailsCard('Invoice Details', [
                      _buildTextField('Invoice Date'),
                      _buildTextField('Delivery Date'),
                      _buildTextField('Sales Person'),
                    ]),
                  ),
                ],
              ),
              _buildDetailsCard('Lens Details', [
                _buildTextField('Lens Category'),
                _buildTextField('Coating'),
                _buildTextField('Lens Stock'),
                _buildTextField('Selling'),
              ]),
              _buildDetailsCard('Prescription', [
                Row(
                  children: [
                    _buildPrescriptionField('SH'),
                    _buildPrescriptionField('SPH'),
                    _buildPrescriptionField('CYL'),
                    _buildPrescriptionField('AXIS'),
                    _buildPrescriptionField('ADD'),
                  ],
                ),
                Row(
                  children: [
                    _buildPrescriptionField('Type'),
                    _buildPrescriptionField('Pay Type'),
                  ],
                ),
              ]),
              _buildDetailsCard('Payment Details', [
                _buildTextField('Total Amount'),
                _buildTextField('Discount'),
                _buildTextField('Fitting Charges'),
                _buildTextField('Grand Total'),
                _buildTextField('Advance Paid'),
                _buildTextField('Balance Amount'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPrescriptionField(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
