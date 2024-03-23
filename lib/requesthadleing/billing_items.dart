// Import statements
import 'package:http/http.dart' as http;
import 'package:optical_desktop/screens/apiservices.dart'; // Correct path to AppService
import 'dart:convert';

Future<void> submitBillingItem({
  required int billingId,
  required int lensId,
  required int frameId,
  required int frameQty,
  required int lensQty,
}) async {
  AppService appService = AppService(); // Create an instance of AppService
  String endpoint = 'billing/billings/items'; // Define the endpoint

  // Use AppService's functionality to get the full URL
  String fullUrl = appService.getFullUrl(endpoint);

  final response = await http.post(
    Uri.parse(fullUrl),
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
