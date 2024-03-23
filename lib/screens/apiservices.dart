import 'package:http/http.dart' as http;
import 'dart:convert';

class AppService {
  // final String _baseUrl = 'http://172.208.26.215/'; 

  final String _baseUrl = 'http://localhost:8001'; // Base URL

  // Add this method
  String getFullUrl(String endpoint) {
    return '$_baseUrl/$endpoint'; // Constructs the full URL by appending the endpoint to the base URL
  }

  Future<String> fetchData(String endpoint) async {
    var fullUrl = getFullUrl(endpoint); // Now using the getFullUrl method
    try {
      var response = await http.get(Uri.parse(fullUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data["message"]; // Assuming the response JSON contains a "message" field
      } else {
        return "Failed to load data from $endpoint!";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}
