import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:optical_desktop/screens/home.dart';
import 'package:optical_desktop/screens/register.dart';
import 'package:optical_desktop/global.dart' as globals;
import 'package:http/http.dart' as http;


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optical Desktop Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    final response = await http.post(
      Uri.parse('http://172.208.26.215/register/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

   if (response.statusCode == 200) {
  final responseData = json.decode(response.body);
  
  if (responseData.containsKey('branchId') && responseData['branchId'] != null) {
    globals.branch_id = responseData['branchId'];  // Directly assign integer value
  } else {
    print("Error: Branch ID not found in response");
    return;
  }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Homescreen ()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }
}


  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 36),
                    ),
                  ),
                     TextButton(
                    onPressed: _navigateToRegister,
                    child: Text('Not registered yet? Sign up here'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implement forgot password action
                    },
                    child: Text('Forgot Password?'),
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