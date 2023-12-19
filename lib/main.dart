import 'package:flutter/material.dart';
import 'package:optical_desktop/screens/login.dart';
import 'package:optical_desktop/screens/register.dart';
import 'screens/billing.dart';
import 'screens/home.dart';  // Assuming you have a billing.dart file inside a screens folder

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
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // Add other dark theme properties if needed
      ),
      themeMode: ThemeMode.dark, // Set theme mode to dark
      home:  Homescreen(), // Ensure you have a constructor marked as const in BillScreen
      debugShowCheckedModeBanner: false,
    );
  }
}
