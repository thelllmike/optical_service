import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:optical_desktop/screens/sidebar/sidebar.dart'; // Ensure this import is correct
import 'package:optical_desktop/global.dart'as globals; 
// Replace with your actual API base URL
const String baseUrl = "http://localhost:8001/product";

Future<http.Response> addProduct(
    String endpoint, Map<String, dynamic> productData) {
    productData['branch_id'] = globals.branch_id;
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
            flex: 5,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: ProductFormSection(
                title: 'Add Lenses',
                fields: [
                  'Lens Category',
                  'Coating',
                  'Power',
                  'Lens Stock',
                  'Selling Price',
                  'Cost'
                ],
                endpoint: 'add_lens',
                tableHeaders: [
                  'Category',
                  'Coating',
                  'power',
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
            flex: 5,
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
  int? editingItemId; // Add this line

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

  Future<http.Response> updateProduct(
      String endpoint, int id, Map<String, dynamic> productData) async {
    String url = '$baseUrl/$endpoint/$id'; // Constructing the URL with the ID
    return http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(productData),
    );
  }

  Future<void> deleteProduct(String endpoint, int id) async {
    try {
      var response = await http.delete(
        Uri.parse('$baseUrl/$endpoint/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product Deleted Successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Deleting Product: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Network Error: $e')));
    }
  }


 Future<void> fetchData() async {
    String fetchEndpoint = widget.endpoint == 'add_lens' ? 'lenses' : 'frames';
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/$fetchEndpoint?branch_id=${globals.branch_id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> dataList = jsonDecode(response.body);
        setState(() {
          tableData = dataList.map((item) {
            List<String> row = [];
            row.add(item['id'].toString()); 
            widget.tableHeaders.forEach((header) {
              String key = convertToKey(header);
              var value = item[key];
              row.add(value != null ? value.toString() : 'N/A');
            });
            return row;
          }).toList();
        });
      } else {
        print('Failed to load data: ${response.body}');
      }
    } catch (e) {
      print('Network Error: $e');
    }
  }



// Future<void> fetchData() async {
//   String fetchEndpoint = widget.endpoint == 'add_lens' ? 'lenses' : 'frames';
//   try {
//     var response = await http.get(Uri.parse('$baseUrl/$fetchEndpoint'));
//     if (response.statusCode == 200) {
//       List<dynamic> dataList = jsonDecode(response.body);
//       setState(() {
//         tableData = dataList.map((item) {
//           List<String> row = [];
//           // Assuming 'id' is the key for the ID in your data
//           // Make sure this key matches the key used in your backend
//           row.add(item['id'].toString()); 
//           // Iterate over the table headers and fill in row data
//           widget.tableHeaders.forEach((header) {
//             String key = convertToKey(header);
//             var value = item[key];
//             row.add(value != null ? value.toString() : 'N/A');
//           });
//           return row;
//         }).toList();
//       });
//     } else {
//       print('Failed to load data: ${response.body}');
//     }
//   } catch (e) {
//     print('Network Error: $e');
//   }
// }


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
        "power": controllers[2].text,
        "stock": controllers[3].text,
        "selling_price": controllers[4].text,
        "cost": controllers[5].text,
        'branch_id': globals.branch_id,
      };
    } else if (widget.endpoint == 'add_frame') {
      productData = {
        //brand
        "frame": controllers[0].text,
        "brand": controllers[1].text,
        "size": controllers[2].text,
        "stock": controllers[3].text,
        "model": controllers[4].text,
        "color": controllers[5].text,
        "selling_price": controllers[6].text,
        "wholesale_price": controllers[7].text,
        'branch_id': globals.branch_id,
      };
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid endpoint: ${widget.endpoint}')));
      return;
    }

    try {
      http.Response response;
      if (editingItemId != null) {
        // Update logic: Call the update API
        print("button pressed: ${editingItemId}");
        response =
            await updateProduct(widget.endpoint, editingItemId!, productData);
      } else {
        // Add logic: Call the add API
        response = await addProduct(widget.endpoint, productData);
      }

      print('Response body: ${response.body}');

      // Check the response and show an appropriate message
      if (response.statusCode == 200) {
        String successMessage = editingItemId != null
            ? 'Product Updated Successfully'
            : 'Product Added Successfully';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(successMessage)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Network Error: $e')));
    } finally {
      // Reset the editing state and clear form fields after the operation
      setState(() {
        editingItemId = null;
        controllers.forEach((controller) => controller.clear());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = widget.tableHeaders
        .map((header) => DataColumn(label: Text(header)))
        .toList();
    columns.add(DataColumn(label: Text('Actions')));

   List<DataRow> rows = tableData.map((data) {
  List<DataCell> cells = data.sublist(1) // Skips the ID column for display
      .map((cell) => DataCell(Text(cell)))
      .toList();

  // Add action buttons (Edit and Delete) to each row
  cells.add(DataCell(Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          int? id = int.tryParse(data[0]); // ID is at index 0
          if (id == null) {
            print("Invalid or missing ID: ${data[0]}");
            return;
          }
          setState(() {
            editingItemId = id;
            // Populate the text fields with the data for editing
            for (int i = 0; i < min(controllers.length, data.length - 1); i++) {
              controllers[i].text = data[i + 1]; // +1 to skip the ID
            }
          });
        },
      ),
   IconButton(
  icon: Icon(Icons.delete),
  onPressed: () {
    int? id = int.tryParse(data[0]); // ID is at index 0
    if (id != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this item?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  deleteProduct(widget.endpoint, id).then((_) {
                    Navigator.of(context).pop(); // Close the dialog
                    fetchData(); // Fetch data again or update the tableData list
                  });
                },
              ),
            ],
          );
        },
      );
    } else {
      print("Invalid ID: ${data[0]}");
    }
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
                  columnSpacing: 15, // Add columnSpacing here
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