// payment_details_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optical_desktop/screens/apiservices.dart';

AppService appService = AppService();

class PaymentDetailsService {
  static Future<bool> submitPaymentDetails({
    required int billingId,
    required double totalAmount,
    required double discount,
    required double fittingCharges,
    required double grandTotal,
    required double advancePaid,
    required double balanceAmount,
    required String payType,
  }) async {
    ///billing/billings/payment-details
    
    final String endpoint = 'billing/billings/payment-details';
    final fullUrl = appService.getFullUrl(endpoint);
    
    // var url = Uri.parse('$fullUrl'); // Change to your actual backend URL
    var response = await http.post(
      Uri.parse(fullUrl), // Correctly using 'fullUrl' here
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'billing_id': billingId,
        'total_amount': totalAmount,
        'discount': discount,
        'fitting_charges': fittingCharges,
        'grand_total': grandTotal,
        'advance_paid': advancePaid,
        'balance_amount': balanceAmount,
        'pay_type': payType,
      }),
    );
    if (response.statusCode == 200) {
      // Assuming a 200 status code means success
      return true;
    } else {
      // Handle error or unsuccessful submission
      print('Failed to submit payment details: ${response.body}');
      return false;
    }
  }
}
