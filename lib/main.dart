import 'package:flutter/material.dart';
import 'screens/billing.dart'; // Assuming you have a billing.dart file inside a screens folder

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BillScreen(), // Changed to BillingScreen which you should have in billing.dart
    );
  }
}

// Here, you can add your BillingScreen in billing.dart.
