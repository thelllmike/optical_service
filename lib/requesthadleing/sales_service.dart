import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optical_desktop/global.dart' as globals;
import 'package:optical_desktop/screens/apiservices.dart';


AppService appService = AppService();

class SalesService {
  static Future<double> fetchCurrentMonthlySales() async {
    // Use AppService instance to construct the URL with the branch ID from globals
    final String endpoint = 'Quary/current-monthly-sales/${globals.branch_id}';
    final String fullUrl = appService.getFullUrl(endpoint);

    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return double.tryParse(data['total_sales'].toString()) ?? 0.0; // Safely parse the sales data
    } else {
      throw Exception('Failed to load sales data. Status code: ${response.statusCode}');
    }
  }

 static Future<int> fetchDailyOrders(DateTime orderDate) async {
    // Construct the URL with the branch ID and order date
    final String endpoint = 'Quary/daily-orders/${globals.branch_id}';
    final String fullUrl = appService.getFullUrl(endpoint);

    // Format the order date as 'YYYY-MM-DD'
    String formattedDate = orderDate.toIso8601String().substring(0, 10);

    // Make the HTTP GET request
    final response = await http.get(
      Uri.parse('$fullUrl?order_date=$formattedDate'),
    );

    if (response.statusCode == 200) {
      // Parse the response JSON
      Map<String, dynamic> data = json.decode(response.body);
      // Extract and return the order count
      return data['order_count'];
    } else {
      // If the request fails, throw an exception
      throw Exception('Failed to load daily orders. Status code: ${response.statusCode}');
    }
    // Use the SalesService.fetchDailyOrders function to get the daily orders count
// Example usage:

  }
static Future<double> fetchTotalSales(DateTime salesDate) async {
    final String endpoint = 'Quary/total-sales/${globals.branch_id}';
    final String formattedDate = salesDate.toIso8601String().substring(0, 10);
    final String fullUrl = appService.getFullUrl('$endpoint?sales_date=$formattedDate');

    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return double.tryParse(data['total_sales'].toString()) ?? 0.0;
    } else {
      throw Exception('Failed to load total sales. Status code: ${response.statusCode}');
    }
  }
 static Future<int> fetchUniqueCustomers(DateTime salesDate) async {
    final String endpoint = 'Quary/unique-customers/${globals.branch_id}';
    final String formattedDate = salesDate.toIso8601String().substring(0, 10);
    final String fullUrl = appService.getFullUrl('$endpoint?sales_date=$formattedDate');

    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return int.tryParse(data['unique_customers_count'].toString()) ?? 0;
    } else {
      throw Exception('Failed to load unique customers count. Status code: ${response.statusCode}');
    }
  }
  

}