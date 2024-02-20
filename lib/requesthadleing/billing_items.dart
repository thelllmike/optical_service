import 'package:http/http.dart' as http;
import 'dart:convert';

// Adjusted function signature to include frame_qty, lens_qty, frame_unit_price, and lens_unit_price
Future<void> submitBillingItem({
  required int billingId,
  required int lensId,
  required int frameId,
  required int frameQty,
  required int lensQty,
///billing/billings/items
}) async {
  final uri = Uri.parse('http://localhost:8001/billing/billings/items'); // Adjust the URL as needed
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'billing_id': billingId,
      'lens_id': lensId,
      'frame_id': frameId,
      'frame_qty': frameQty,
      'lens_qty': lensQty,
 
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Billing Item Created with ID: ${data['id']}');
  } else {
    print('Failed to create billing item. Status code: ${response.statusCode}');
  }
}
