import 'dart:convert';
import 'package:http/http.dart' as http;

class DeliveryDateService {
  static const String _baseUrl = 'http://localhost:8001';

  static Future<bool> submitBilling({
    required String invoiceDate,
    required String deliveryDate,
    required String salesPerson,
    required int customerId, // Add this line to accept customer_id
    // Additional fields as necessary
  }) async {
    final uri = Uri.parse('$_baseUrl/billing/billings');
    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'invoice_date': invoiceDate,
          'delivery_date': deliveryDate,
          'sales_person': salesPerson,
          'customer_id': customerId, // Add this line to include customer_id in the request body
          // Other fields as necessary
        }));

    if (response.statusCode == 200) {
      // Handle success
      return true;
    } else {
      // Handle failure
      return false;
    }
  }
}
