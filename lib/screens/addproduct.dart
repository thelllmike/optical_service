import 'package:flutter/material.dart';
import 'package:optical_desktop/screens/sidebar/sidebar.dart';

class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Row(
        children: <Widget>[
          Sidebar(), // Use the Sidebar widget from sidebar.dart
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: SingleChildScrollView( // Allows for scrolling if content is too long
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProductFormSection(title: 'Add Frames', fields: [
                    'Frame',
                    'Brand',
                    'Size',
                    'Frame Stock',
                    'Model',
                    'Color',
                    'Quantity',
                    'Selling Price',
                    'Whole Price',
                  ]),
                  SizedBox(height: 24), // Spacing between sections
                  ProductFormSection(title: 'Add Lenses', fields: [
                    'Lens Category',
                    'Coating',
                    'Lens Stock',
                    'Selling sale',
                    'whole sale',
                    'Quantity',
                  ]),
                ],
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

  const ProductFormSection({
    Key? key,
    required this.title,
    required this.fields,
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
        // You can access the text of each field using controllers[index].text
      },
      child: Text('Save'),
    ));

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
        // Placeholder for the list of added products if needed
      ],
    );
  }
}
