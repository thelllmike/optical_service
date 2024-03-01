// payment_details_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

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
    var url = Uri.parse('http://localhost:8001/billing/billings/payment-details'); // Change to your actual backend URL
    var response = await http.post(
      url,
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
