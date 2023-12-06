import 'package:flutter/material.dart';
import 'package:optical_desktop/screens/home.dart';
import '../home.dart'; // Import Homescreen

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: 0,
      onDestinationSelected: (int index) {
        if (index == 0) { // Assuming 0 is the index for 'Home'
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Homescreen()),
          );
        }
        // Add other cases for different indices if needed
      },
     labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(Icons.home_filled),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bar_chart),
          selectedIcon: Icon(Icons.bar_chart),
          label: Text('Charts'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.payments),
          selectedIcon: Icon(Icons.payments),
          label: Text('Payroll'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.add_photo_alternate),
          selectedIcon: Icon(Icons.add_photo_alternate_outlined),
          label: Text('Add Frames'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.remove_red_eye),
          selectedIcon: Icon(Icons.remove_red_eye_outlined),
          label: Text('Fitting Lenses'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.receipt_long),
          selectedIcon: Icon(Icons.receipt),
          label: Text('Invoice'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_add),
          selectedIcon: Icon(Icons.person_add_alt_1),
          label: Text('Add Employee'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.money_off),
          selectedIcon: Icon(Icons.money_off_csred),
          label: Text('Expenses'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}