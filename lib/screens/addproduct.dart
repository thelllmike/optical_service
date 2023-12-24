import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:optical_desktop/screens/sidebar/sidebar.dart'; // Ensure this import is correct

// Replace with your actual API base URL
const String baseUrl = "http://localhost:8001";

Future<http.Response> addProduct(
    String endpoint, Map<String, dynamic> productData) {
  return http.post(
    Uri.parse('$baseUrl/$endpoint'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(productData),
  );
}

class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Row(
        children: <Widget>[
          Sidebar(), // Uncomment and ensure the Sidebar widget is correctly implemented
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: ProductFormSection(
                title: 'Add Lenses',
                fields: [
                  'Lens Category',
                  'Coating',
                  'Lens Stock',
                  'Selling Price',
                  'Cost'
                ],
                endpoint: 'add_lens',
                tableHeaders: [
                  'Category',
                  'Coating',
                  'stock',
                  'selling_price',
                  'Cost'
                ], // Add your table headers
                tableData: [], // Add your table data
              ),
            ),
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: ProductFormSection(
                title: 'Add Frames',
                fields: [
                  'Frame',
                  'Brand',
                  'Size',
                  'Frame Stock',
                  'Model',
                  'Color',
                  'Selling Price',
                  'Wholesale Price'
                ],
                endpoint: 'add_frame',
                tableHeaders: [
                  'Frame',
                  'Brand',
                  'Size',
                  'stock',
                  'Model',
                  'Color',
                  'selling_price',
                  'wholesale_price',
                ], // Add your table headers
                tableData: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductFormSection extends StatefulWidget {
  final String title;
  final List<String> fields;
  final List<String> tableHeaders;
  final String endpoint;

  const ProductFormSection({
    Key? key,
    required this.title,
    required this.fields,
    required this.endpoint,
    required this.tableHeaders,
    required List tableData,
  }) : super(key: key);

  @override
  _ProductFormSectionState createState() => _ProductFormSectionState();
}

class _ProductFormSectionState extends State<ProductFormSection> {
  late List<TextEditingController> controllers;
  List<List<String>> tableData = []; // Define tableData as a state variable
  // List<List<dynamic>> tableData = []; // Define tableData as a state variable

  @override
  void initState() {
    super.initState();
    controllers = widget.fields.map((_) => TextEditingController()).toList();
    fetchData(); // Fetch data when the widget is initialized
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> fetchData() async {
    String fetchEndpoint = widget.endpoint == 'add_lens' ? 'lenses' : 'frames';
    try {
      var response = await http.get(Uri.parse('$baseUrl/$fetchEndpoint'));
      if (response.statusCode == 200) {
        List<dynamic> dataList = jsonDecode(response.body);
        setState(() {
          tableData = dataList.map((item) {
            return widget.tableHeaders.map((header) {
              String key = convertToKey(header);
              // Check if the item is a Map and contains the key
              if (item is Map<String, dynamic> && item.containsKey(key)) {
                // Check for null before calling toString
                var value = item[key];
                return value != null ? value.toString() : 'N/A';
              }
              return 'N/A'; // Default value if key is not present
            }).toList();
          }).toList();
        });
      } else {
        print('Failed to load data: ${response.body}');
      }
    } catch (e) {
      print('Network Error: $e');
    }
  }

  String convertToKey(String header) {
    // Your conversion logic here, ensure it matches the JSON response keys
    return header.replaceAll(' ', '_').toLowerCase();
  }

  Future<void> handleSubmit() async {
    Map<String, dynamic> productData;

    // Determine which form is being submitted by checking the endpoint
    if (widget.endpoint == 'add_lens') {
      productData = {
        "category": controllers[0].text,
        "coating": controllers[1].text,
        "stock": controllers[2].text,
        "selling_price": controllers[3].text,
        "cost": controllers[4].text,
      };
    } else if (widget.endpoint == 'add_frame') {
      productData = {
        "brand": controllers[0].text,
        "frame": controllers[1].text,
        "size": controllers[2].text,
        "stock": controllers[3].text,
        "model": controllers[4].text,
        "color": controllers[5].text,
        "selling_price": controllers[6].text,
        "wholesale_price": controllers[7].text,
      };
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid endpoint: ${widget.endpoint}')));
      return;
    }

    try {
      var response = await addProduct(widget.endpoint, productData);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product Added Successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error Adding Product: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Network Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = widget.tableHeaders
        .map((header) => DataColumn(label: Text(header)))
        .toList();
        columns.add(DataColumn(label: Text('Actions')));
     
     

    List<DataRow> rows = tableData.map((data) {
        List<DataCell> cells = data.map((cell) => DataCell(Text(cell.toString()))).toList();

        // Add the action buttons to each row
        cells.add(DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Implement edit functionality
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Implement delete functionality
              },
            ),
          ],
        )));

        return DataRow(cells: cells);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Your form fields and Save button...
                for (var i = 0; i < widget.fields.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      controller: controllers[i],
                      decoration: InputDecoration(
                        labelText: widget.fields[i],
                        border: OutlineInputBorder(),
                      ),
                      
                    ),
                  ),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text('Save'),
                ),
                DataTable(
                  columnSpacing: 25, // Add columnSpacing here
                  columns: columns,
                  rows: rows,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
