import 'package:flutter/material.dart';


final ValueNotifier<ThemeData> _themeNotifier = ValueNotifier(ThemeData.dark());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: _themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: BillScreen(),
        );
      },
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
        title: Text('Optical Service'),
        actions: [
     IconButton(
  icon: Icon(Icons.settings),
  onPressed: () {
    _themeNotifier.value = (_themeNotifier.value.brightness == Brightness.dark)
        ? ThemeData.light()
        : ThemeData.dark();
  },
)

        ],
      ),
     body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCustomerDetailsSection(), flex: 1),
                  SizedBox(width: 8),
                  Expanded(child: _buildFrameDetailsSection(), flex: 1),
                  SizedBox(width: 8),
                  Expanded(child: _buildInvoiceAndDeliveryDetailsSection(), flex: 1),
                ],
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildLensDetailsSection(), flex: 1),
                  SizedBox(width: 8),
                  Expanded(child: _buildPrescriptionDetailsSection(), flex: 1),
                  SizedBox(width: 8),
                  Expanded(child: _buildPaymentDetailsSection(), flex: 1),
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
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 4),
            ...children,
          ],
        ),
      ),
    );
  }

Widget _buildTextField(String label, {int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      ),
      maxLines: maxLines,
      style: TextStyle(fontSize: 14),
    ),
  );
}


  Widget _buildDropdownField(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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
