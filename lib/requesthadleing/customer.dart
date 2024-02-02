import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optical_desktop/global.dart' as globals; // If needed

class CustomerPostService {
  static const _baseUrl = 'http://localhost:8001/billing';

  static Future<bool> postCustomerDetails({
    required String mobileNumber,
    required String fullName,
    required String nicNumber,
    required String address,
    required String gender,
  }) async {
    final uri = Uri.parse('$_baseUrl/customers');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobile_number': mobileNumber,
          'full_name': fullName,
          'nic_number': nicNumber,
          'address': address,
          'gender': gender,
          'branch_id': globals.branch_id //if your API requires it
        }),
      );

      if (response.statusCode == 200) {
        // Assuming a successful response indicates success
        return true;
      } else {
        // Log or handle the error based on your needs
        print('Failed to post customer details: ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle exceptions from HTTP request
      print('Exception when posting customer details: $e');
      return false;
    }
  }
}
