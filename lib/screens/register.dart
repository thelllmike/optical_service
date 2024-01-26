import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For JSON encoding/decoding



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optical Desktop Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController opticalShopController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController headOfficeAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String getBranchCode() {
    return opticalShopController.text.trim() + '-' + branchNameController.text.trim();
  }



  Future<int> registerOpticalShop() async {
  var url = Uri.parse('http://localhost:8001/register/create/optical_shop');
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'shop_name': opticalShopController.text,
      'head_office_address': headOfficeAddressController.text,
      'contact_number': mobileNumberController.text,
      'email': emailController.text,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    return responseData['id'];
  } else {
    throw Exception('Failed to register optical shop');
  }
}

Future<int> registerBranch(int shopId) async {
  var url = Uri.parse('http://localhost:8001/register/create/branch');
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'shop_id': shopId.toString(),
      'branch_name': branchNameController.text,
      'branch_code': getBranchCode(),
      'mobile_number': mobileNumberController.text,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    return responseData['id'];  // Assuming the ID is returned in the response
  } else {
    throw Exception('Failed to register branch');
  }
}



  Future<void> registerUser(int branchId) async {
  var url = Uri.parse('http://localhost:8001/register/create/user');
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': emailController.text,
      'password': passwordController.text,
      'branch_id': branchId.toString(),
      'role': 'owner', // Modify as needed
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to register user');
  }
}


 Future<void> completeRegistrationProcess() async {
  try {
    // First, register the optical shop and get its ID
    final int shopId = await registerOpticalShop();

    // Then, register the branch with the obtained shop ID
    final int branchId = await registerBranch(shopId);

    // Finally, register the user with the obtained branch ID
    await registerUser(branchId);

    Fluttertoast.showToast(msg: 'Complete registration successful');
  } catch (e) {
    Fluttertoast.showToast(msg: 'Registration failed: ${e.toString()}');
    print(e.toString());
  }
}


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text == confirmPasswordController.text) {
        completeRegistrationProcess();
      } else {
        Fluttertoast.showToast(msg: 'Passwords do not match');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: opticalShopController,
                    decoration: InputDecoration(
                      hintText: 'Optical Shop Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter optical shop name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: branchNameController,
                    decoration: InputDecoration(
                      hintText: 'Branch Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter branch name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      // Add more sophisticated email validation if needed
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter mobile number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: headOfficeAddressController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Head Office Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter head office address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 36),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
