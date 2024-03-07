import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:optical_desktop/screens/login.dart';
// Other imports...

void main() => runApp(MyApp());

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
      ),
      themeMode: ThemeMode.dark,
      home: AnimatedSplashScreen(
        duration: 4000,
        splash: Container(
          width: 1920 , // Specify the width of the box
          height: 1080, // Specify the height of the box
          decoration: BoxDecoration(
            color: Colors.white, // This matches the box's background color
            borderRadius: BorderRadius.circular(10), // Box border radius
          ),
          child: Center(
            child: Lottie.asset('assets/animations/1709781075179.json'),
          ),
        ),
        nextScreen: LoginScreen(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white, // Set to match the box's background or your desired splash background
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
