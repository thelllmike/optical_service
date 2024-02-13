import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optical_desktop/global.dart' as globals;

class CustomerPostService {
  static const _baseUrl = 'http://localhost:8001/billing';

  static Future<int?> postCustomerDetails({
    required String mobileNumber,
    required String fullName,
    String? nicNumber, // Made optional to match your API capability
    String? address,
    String? gender,
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
          'branch_id': globals.branch_id,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final customerId = data['id'];
          print('Customer ID: $customerId');
        if (customerId != null) {
          return customerId is int ? customerId : int.tryParse(customerId.toString());
         
        } else {
          print('Customer ID not found in the response');
          return null;
        }
      } else {
        print('Failed to post customer details (Status Code: ${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception when posting customer details: $e');
      return null;
    }
  }
}
