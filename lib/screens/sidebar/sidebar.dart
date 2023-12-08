import 'package:flutter/material.dart';
import 'package:optical_desktop/screens/home.dart';
import 'package:optical_desktop/screens/addproduct.dart';
import '../billing.dart';  // Import Homescreen

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: 0,
      onDestinationSelected: (int index) {
        switch (index) {
          case 0: // Index for 'Home'
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homescreen()),
            );
            break;
          // ... include other cases for different indices here
          case 2: // Index for 'Add Frames & Lenses'
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductScreen()), // Navigate to AddProductScreen
            );
            break;
          case 7: // Assuming 7 is the index for 'Billing'
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BillScreen()), // Navigate to BillScreen
            );
            break;
          // Add other cases for different destinations
          // ... other cases ...
        }
      },
     labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(Icons.home_filled),
          label: Text('Home'),
        ),
       
        NavigationRailDestination(
          icon: Icon(Icons.payments),
          selectedIcon: Icon(Icons.payments),
          label: Text('Payroll'),
        ),
         NavigationRailDestination(
          icon: Icon(Icons.inventory),
          selectedIcon: Icon(Icons.inventory_2),
          label: Text('Add Frames & Lenses'),
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
          icon: Icon(Icons.receipt),
          selectedIcon: Icon(Icons.receipt_long),
          label: Text('Billing'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.exit_to_app),
          selectedIcon: Icon(Icons.exit_to_app),
          label: Text('Logout'),
        ),
      ],
    );
  }
}