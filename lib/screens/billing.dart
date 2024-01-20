import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart';

final ValueNotifier<ThemeData> _themeNotifier = ValueNotifier(ThemeData.dark());

class Item {
  String description;
  int quantity;
  double unitPrice;

  Item(
      {required this.description,
      required this.quantity,
      required this.unitPrice});

  double get totalAmount => quantity * unitPrice;
}

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
  List<String> frames = [];
  List<String> brands = [];
  List<String> sizes = [];
  List<String> models = [];
  List<String> colors = [];

 String? selectedFrame;
String? selectedBrand;
String? selectedSize;
  String? Value; // Initially null

  Map<String, TextEditingController> _controllers = {};
  DateTime _selectedDate = DateTime.now();
  List<Item> items = [
    Item(description: 'Item 1', quantity: 1, unitPrice: 10.0)
  ];
  bool _isSidebarVisible = false;

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchFramesData();
    _fetchColorsData();
    _fetchModelsData();
    
  }

  Future<void> _fetchModelsData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8001/dropdown/onlymodel'));
      if (response.statusCode == 200) {
        List<String> fetchedModels = (json.decode(response.body) as List)
            .map((data) =>
                data.toString()) // Assuming the API returns a list of strings
            .toList();

        setState(() {
          models = fetchedModels;
        });
      } else {
        // Handle the error; maybe show a message to the user
      }
    } catch (e) {
      // Handle any exceptions; maybe show an error message
    }
  }

  Future<void> _fetchColorsData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8001/dropdown/onlycolor'));
      if (response.statusCode == 200) {
        List<String> fetchedcolors = (json.decode(response.body) as List)
            .map((data) =>
                data.toString()) // Assuming the API returns a list of strings
            .toList();

        setState(() {
          colors = fetchedcolors;
        });
      } else {
        // Handle the error; maybe show a message to the user
      }
    } catch (e) {
      // Handle any exceptions; maybe show an error message
    }
  }



  Future<void> _fetchFramesData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8001/dropdown/onlyframe'));
      if (response.statusCode == 200) {
        List<String> fetchedFrames = (json.decode(response.body) as List)
            .map((data) =>
                data.toString()) // Assuming the API returns a list of strings
            .toList();

        setState(() {
          frames = fetchedFrames;
        });
      } else {
        // Handle the error; maybe show a message to the user
      }
    } catch (e) {
      // Handle any exceptions; maybe show an error message
    }
  }
///dropdown/brands-by-frame
///filter by frames which we selected
   Future<void> _fetchBrandsByFrame(String frame) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8001/dropdown/brands-by-frame?frame=$frame'));

      if (response.statusCode == 200) {
        List<String> fetchedBrands = List<String>.from(json.decode(response.body));
        
        setState(() {
          brands = fetchedBrands;
        });
      } else {
        // Handle the error; maybe show a message to the user
      }
    } catch (e) {
      // Handle any exceptions; maybe show an error message
    }
  }
//filtered bybrand and frame and get details
///dropdown/sizes-by-frame-and-brand
  Future<void> _fetchSizesByFrameAndBrand(String frame, String brand) async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:8001/dropdown/sizes-by-frame-and-brand?frame=$frame&brand=$brand'),
    );

    if (response.statusCode == 200) {
      List<String> fetchedSizes = List<String>.from(json.decode(response.body));
      
      setState(() {
        sizes = fetchedSizes;
      });
    } else {
      // Handle the error; maybe show a message to the user
    }
  } catch (e) {
    // Handle any exceptions; maybe show an error message
  }
}






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
            icon: Icon(Icons.notifications),
            onPressed: () {
              _themeNotifier.value =
                  (_themeNotifier.value.brightness == Brightness.dark)
                      ? ThemeData.light()
                      : ThemeData.dark();
            },
          )
        ],
      ),
      body: Row(
        children: [
          Sidebar(),
          Expanded(child: _buildMainContent()),
        ],
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

Widget _buildDropdownField(String label, List<String> items, {String? value, required Function(String) onSelected}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3.0),
          borderSide: BorderSide(),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        isDense: true,
      ),
      value: value, // Set the current value for the dropdown
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 10),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          onSelected(newValue);
        }
      },
      style: TextStyle(fontSize: 10),
      isExpanded: true,
    ),
  );
}

  Widget _buildMainContent() {
    return SingleChildScrollView(
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
                Expanded(
                    child: _buildInvoiceAndDeliveryDetailsSection(), flex: 1),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildLensDetailsSection(), flex: 1),
                SizedBox(width: 8),
                // Expanded(child: _buildPrescriptionDetailsSection(), flex: 1),
                SizedBox(width: 8),
                Expanded(child: _buildPrescriptionDetailsSection(), flex: 1),
                // Expanded(child: _buildPaymentDetailsSection(), flex: 1),
                //table
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildItemTable(), flex: 1),
                SizedBox(width: 8),
                // Expanded(child: _buildPrescriptionDetailsSection(), flex: 1),
                SizedBox(width: 8),
                Expanded(child: _buildPaymentDetailsSection(), flex: 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // This method builds the prescription details section
  Widget _buildPrescriptionDetailsSection() {
    return _buildDetailsCard('Prescription Details', [
      _buildEditableTable(),
    ]);
  }

  Widget _buildEditableCell(String key) {
    // Create a controller if it doesn't exist
    _controllers.putIfAbsent(key, () => TextEditingController());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildCustomerDetailsSection() {
    return _buildDetailsCard('Customer Details', [
      _buildTextField('Mobile Number'),
      _buildTextField('Full Name'),
      _buildTextField('NIC Number'),
      _buildTextField('Address', maxLines: 3),
      _buildDropdownField('Gender', ['Male', 'Female', 'Other'], onSelected: (String ) {  }),
    ]);
  }


Widget _buildFrameDetailsSection() {
  return _buildDetailsCard('Frame Details', [
    _buildDropdownField(
      'Frame',
      frames,
      value: selectedFrame, // Use the selectedFrame as the value
      onSelected: (newValue) {
        if (newValue != selectedFrame) {
          setState(() {
            selectedFrame = newValue;
            selectedBrand = null; // Reset brand when frame changes
            selectedSize = null; // Reset size when frame changes
            brands = []; // Clear previous brands
            sizes = []; // Clear previous sizes
          });
          _fetchBrandsByFrame(newValue);
        }
      },
    ),
    _buildDropdownField(
      'Brand',
      brands,
      value: selectedBrand, // Use the selectedBrand as the value
      onSelected: (newValue) {
        if (newValue != selectedBrand) {
          setState(() {
            selectedBrand = newValue;
            selectedSize = null; // Reset size when brand changes
            sizes = []; // Clear previous sizes
          });
          if (selectedFrame != null) {
            _fetchSizesByFrameAndBrand(selectedFrame!, newValue);
          }
        }
      },
    ),
    _buildDropdownField(
      'Size',
      sizes,
      value: selectedSize, // Use the selectedSize as the value
      onSelected: (newValue) {
        setState(() {
          selectedSize = newValue;
        });
      },
    ),
    _buildTextField('Quantity'),
    _buildDropdownField('Model', models, onSelected: (String ) {  }),
    _buildDropdownField('Color', colors, onSelected: (String ) {  }),
    _buildTextField('Price'),
  ]);
}


  Widget _buildInvoiceAndDeliveryDetailsSection() {
    return _buildDetailsCard('Invoice & Delivery Details', [
      _buildDatePickerField('Invoice Date'),
      _buildDatePickerField('Delivery Date'),
      _buildDropdownField('Sales Person', ['Person1', 'Person2'], onSelected: (String ) {  }),
    ]);
  }

  Widget _buildLensDetailsSection() {
    return _buildDetailsCard('Lens Details', [
      _buildDropdownField('Lens Category', ['Category1', 'Category2'], onSelected: (String ) {  }),
      _buildDropdownField('Coating', ['Coating1', 'Coating1'], onSelected: (String ) {  }),
      _buildDropdownField('Power', ['-1', '+2'], onSelected: (String ) {  }),
      _buildTextField('Quntity'),
      _buildTextField('Price'),
    ]);
  }

// This method builds the editable table for the prescription details
  Widget _buildEditableTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('SPH')),
          DataColumn(label: Text('CYL')),
          DataColumn(label: Text('AXIS')),
          DataColumn(label: Text('ADD')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('R')),
            DataCell(_buildEditableCell('R_SPH')),
            DataCell(_buildEditableCell('R_CYL')),
            DataCell(_buildEditableCell('R_AXIS')),
            DataCell(_buildEditableCell('R_ADD')),
          ]),
          DataRow(cells: [
            DataCell(Text('L')),
            DataCell(_buildEditableCell('L_SPH')),
            DataCell(_buildEditableCell('L_CYL')),
            DataCell(_buildEditableCell('L_AXIS')),
            DataCell(_buildEditableCell('L_ADD')),
          ]),
        ],
      ),
    );
  }

//description table

  Widget _buildItemTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Qty')),
        DataColumn(label: Text('Unit Price')),
        DataColumn(label: Text('Total Amount')),
        DataColumn(label: Text('Delete')), // Column for delete button
      ],
      rows: List<DataRow>.generate(
        items.length,
        (index) => DataRow(
          cells: [
            DataCell(Text(items[index].description)),
            DataCell(Text(items[index].quantity.toString())),
            DataCell(Text('${items[index].unitPrice}')),
            DataCell(Text('${items[index].totalAmount}')),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteItem(index),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailsSection() {
    return _buildDetailsCard('Payment Details', [
      _buildTextField('Total Amount'),
      _buildTextField('Discount'),
      _buildTextField('Fitting Charges'),
      _buildTextField('Grand Total'),
      _buildTextField('Advance Paid'),
      _buildTextField('Balance Amount'),
      _buildDropdownField('Pay Type', ['Cash', 'Card'], onSelected: (String ) {  }),
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
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
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
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
          contentPadding: EdgeInsets.symmetric(
              vertical: 12.0, horizontal: 10.0), // Smaller padding
          isDense: true, // Added to reduce the height
        ),
        maxLines: maxLines,
        style: TextStyle(fontSize: 14), // Smaller font size
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
              contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 10.0), // Smaller padding
              isDense: true, // Added to reduce the height
            ),
            controller: TextEditingController(
                text: _selectedDate.toLocal().toString().split(' ')[0]),
            style: TextStyle(fontSize: 12), // Smaller font size
          ),
        ),
      ),
    );
  }
}
