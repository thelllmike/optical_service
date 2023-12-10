import 'package:flutter/material.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart'; // Ensure this import is correct

class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Row(
        children: <Widget>[
          Sidebar(), // Added Sidebar
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: ProductFormSection(
                title: 'Add Lenses',
                fields: [
                  'Lens Category',
                  'Coating',
                  'Lens Stock',
                  'Selling Price',
                  'Cost',
                
                ],
                tableHeaders: ['Category', 'Coating', 'Stock', ' S.Price','Cost'], // Add your table headers
                tableData: [], // Add your table data
              ),
            ),
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            flex: 1,
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
                  'Wholesale Price',
                ],
                tableHeaders: ['Frame', 'Brand', 'Size','Qnt', 'Model', 'Color'  ,'S.price','Cost' ], // Add your table headers
                tableData: [], // Add your table data
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
  final List<List<String>> tableData;

  const ProductFormSection({
    Key? key,
    required this.title,
    required this.fields,
    required this.tableHeaders,
    required this.tableData,
  }) : super(key: key);

  @override
  _ProductFormSectionState createState() => _ProductFormSectionState();
}

class _ProductFormSectionState extends State<ProductFormSection> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = widget.fields.map((_) => TextEditingController()).toList();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> formFields = List.generate(widget.fields.length, (index) {
      return TextField(
        controller: controllers[index],
        decoration: InputDecoration(
          labelText: widget.fields[index],
          border: OutlineInputBorder(),
        ),
      );
    });

    formFields.add(SizedBox(height: 16));
    formFields.add(ElevatedButton(
      onPressed: () {
        // Implement your logic to handle form submission
      },
      child: Text('Save'),
    ));

    formFields.add(SizedBox(height: 16));
    formFields.add(buildTable()); // Add the table to the form

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
              children: formFields,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTable() {
    return DataTable(
      columns: widget.tableHeaders
          .map((header) => DataColumn(label: Text(header)))
          .toList(),
      rows: widget.tableData
          .map((row) => DataRow(
                cells: row.map((cell) => DataCell(Text(cell))).toList(),
              ))
          .toList(),
    );
  }
}
