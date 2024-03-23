import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optical_desktop/global.dart' as globals;
import 'package:optical_desktop/screens/apiservices.dart';

  AppService appService = AppService(); // Create an instance of AppService
  


class CustomerService {
  

  // Fetch customer details by mobile number and return the customer ID if found.
  static Future<int?> fetchCustomerDetails(String mobileNumber) async {
      final String endpoint = 'billing/customers/by-phone/$mobileNumber';
        final fullUrl = appService.getFullUrl(endpoint);
    try {
       final response = await http.get(Uri.parse(fullUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final customerId = data['id'];
        return customerId is int ? customerId : int.tryParse(customerId.toString());
      } else {
        print('Customer not found (Status Code: ${response.statusCode})');
        return null;
      }
    } catch (e) {
      print('Exception when fetching customer details: $e');
      return null;
    }
  }

  // Create a new customer and return the new customer's ID.
  static Future<int?> createNewCustomer({
    required String mobileNumber,
    required String fullName,
    String? nicNumber,
    String? address,
    String? gender,
  }) async {
      final String endpoint = 'billing/customers'; // Adjusted endpoint
        final fullUrl = appService.getFullUrl(endpoint); // Correct use of appService
    try {
      final response = await http.post(
       Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobile_number': mobileNumber,
          'full_name': fullName,
          'nic_number': nicNumber,
          'address': address,
          'gender': gender,
          'branch_id': globals.branch_id,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final customerId = data['id'];
        return customerId is int ? customerId : int.tryParse(customerId.toString());
      } else {
        print('Failed to create new customer (Status Code: ${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception when creating new customer: $e');
      return null;
    }
  }
}
