import 'package:flutter/material.dart';

// Assuming the EmployeeScreen is a page to add new employees and list them
class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  // Form key to validate the form
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers to retrieve the values from the form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Management'),
      ),
      body: Row(
        children: <Widget>[
          // Sidebar() goes here if you want to include it
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Text('Employee add', style: Theme.of(context).textTheme.headline6),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter the name';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _mobileNumberController,
                      decoration: InputDecoration(labelText: 'Mobile Number'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter the mobile number';
                        return null;
                      },
                    ),

                             TextFormField(
                      controller: _mobileNumberController,
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter the address';
                        return null;
                      },
                    ),

                           TextFormField(
                      controller: _mobileNumberController,
                      decoration: InputDecoration(labelText: 'Role'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter the role';
                        return null;
                      },
                    ),

                           TextFormField(
                      controller: _mobileNumberController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter the email';
                        return null;
                      },
                    ),

                              TextFormField(
                      controller: _mobileNumberController,
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter the password';
                        return null;
                      },
                    ),

                              TextFormField(
                      controller: _mobileNumberController,
                      decoration: InputDecoration(labelText: 'Confirm Password'),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter the confirm password';
                        return null;
                      },
                    ),

                    // ... Add other TextFormFields for address, role, email, and password
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process data
                        }
                      },
                      child: Text('Save'),
                    ),
                    SizedBox(height: 20),
                    Text('Employee List', style: Theme.of(context).textTheme.headline6),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Mobile Number')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: const <DataRow>[
                        // Populate data rows with actual data
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
