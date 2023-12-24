import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://localhost:800"; // Your API base URL

  Future<http.Response> addLens(Map<String, dynamic> lensData) {
    return http.post(
      Uri.parse('$baseUrl/add_lens'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(lensData),
    );
  }

  // Similarly, create methods for addFrame, updateLens, updateFrame, deleteLens, deleteFrame
}
