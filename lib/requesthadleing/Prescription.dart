import 'dart:convert';
import 'package:http/http.dart' as http;

// Prescription.dart

class Prescription {
  final int customer_id;
  final String rightPd; // Added right PD
  final String rightSph;
  final String rightCyl;
  final String rightAxis;
  final String rightAdd;
  final String leftPd; // Added left PD
  final String leftSph;
  final String leftCyl;
  final String leftAxis;
  final String leftAdd;

  Prescription({
    required this.customer_id,
    required this.rightPd, // Added right PD
    required this.rightSph,
    required this.rightCyl,
    required this.rightAxis,
    required this.rightAdd,
    required this.leftPd, // Added left PD
    required this.leftSph,
    required this.leftCyl,
    required this.leftAxis,
    required this.leftAdd,
  });

  Map<String, dynamic> toJson() => {
        'customer_id': customer_id,
        'right_pd': rightPd, // Added right PD
        'right_sph': rightSph,
        'right_cyl': rightCyl,
        'right_axis': rightAxis,
        'right_add': rightAdd,
        'left_pd': leftPd, // Added left PD
        'left_sph': leftSph,
        'left_cyl': leftCyl,
        'left_axis': leftAxis,
        'left_add': leftAdd,
      };
}



////billing/prescriptions
class PrescriptionService {
  static const String _baseUrl = 'http://172.208.26.215/billing/prescriptions';

  static Future<bool> submitPrescription({required Prescription prescription}) async {
    final uri = Uri.parse(_baseUrl);
    String jsonString = jsonEncode(prescription.toJson());
    
    // Print the JSON string
    print("Sending data to backend: $jsonString");
    
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonString,
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}



