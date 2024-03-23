import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optical_desktop/screens/apiservices.dart';

AppService appService = AppService();

class DeliveryDateService {
  // static const String _baseUrl = 'http://172.208.26.215';

  // Updating the return type to a more specific Future that returns a custom class or map
  static Future<Map<String, dynamic>> submitBilling({
    required String invoiceDate,
    required String deliveryDate,
    required String salesPerson,
    required int customerId,
  }) async {
      final String endpoint = 'billing/billings';
      final fullUrl = appService.getFullUrl(endpoint);
    // final Uri uri = Uri.parse('$_baseUrl/billing/billings');
///billing/billings/items
    // Validate input parameters here if necessary
    if (invoiceDate.isEmpty || deliveryDate.isEmpty || salesPerson.isEmpty || customerId <= 0) {
      return {'success': false, 'error': 'Invalid input parameters'};
    }

    try {
      final response = await http.post(
        Uri.parse(fullUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'invoice_date': invoiceDate,
          'delivery_date': deliveryDate,
          'sales_person': salesPerson,
          'customer_id': customerId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final billingId = data['id'];
        if (billingId != null) {
          return {
            'success': true,
            'billingId': billingId is int ? billingId : int.tryParse(billingId.toString()),
          };
        } else {
          return {'success': false, 'error': 'Billing ID not found in the response'};
        }
      } else {
        return {
          'success': false,
          'error': 'Failed to submit billing information (Status Code: ${response.statusCode}): ${response.body}'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Exception when submitting billing information: $e'};
    }
  }
}
