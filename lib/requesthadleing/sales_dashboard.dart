import 'dart:convert';
import 'package:http/http.dart' as http;

class MonthlySalesData {
  final int year;
  final int month;
  final double totalSales;

  MonthlySalesData({required this.year, required this.month, required this.totalSales});

  factory MonthlySalesData.fromJson(Map<String, dynamic> json) {
    return MonthlySalesData(
      year: json['year'],
      month: json['month'],
      totalSales: json['total_sales'].toDouble(),
    );
  }
}


Future<List<MonthlySalesData>> fetchMonthlySalesData() async {
  final response = await http.get(Uri.parse('http://172.208.26.215/Quary/monthly-sales'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => MonthlySalesData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load monthly sales data');
  }
}

