import 'dart:convert';
import 'package:http/http.dart' as http;

// Prescription.dart

class Prescription {
  final int customer_id; // Added based on Swagger example
  final String rightSph;
  final String rightCyl;
  final String rightAxis;
  final String leftSph;
  final String leftCyl;
  final String leftAxis;
  final String leftAdd;
  final String rightAdd;
 

  Prescription({
    required this.customer_id, // Added
    required this.rightSph,
    required this.rightCyl,
    required this.rightAxis,
    required this.leftSph,
    required this.leftCyl,
    required this.leftAxis,
    required this.leftAdd,
    required this.rightAdd,

  });

  Map<String, dynamic> toJson() => {
        'customer_id': customer_id, // Added
        'right_sph': rightSph,
        'right_cyl': rightCyl,
        'right_axis': rightAxis,
        'left_sph': leftSph,
        'left_cyl': leftCyl,
        'left_axis': leftAxis,
        'left_add': leftAdd,
        'right_add': rightAdd,
      
      };
}


////billing/prescriptions
class PrescriptionService {
  static const String _baseUrl = 'http://localhost:8001/billing/prescriptions';

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


