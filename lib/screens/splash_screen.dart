import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:optical_desktop/screens/login.dart'; // Make sure the import path matches your project structure


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: AnimatedSplashScreen(
        duration: 4000, // Duration in milliseconds, adjust to suit your animation's length
        splash: Lottie.asset('assets/animations/1709781075179.json'),
        nextScreen: LoginScreen(), // The screen to navigate to after your animation
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white, // Set a background color
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
