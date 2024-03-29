import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optical_desktop/global.dart' as globals;
import 'package:optical_desktop/screens/apiservices.dart';

AppService appService = AppService();

class UpdateStockService {
  Future<void> updateLensStock(int lensId, int lensQty) async {

  final String endpoint = 'product/update-lens-stock';
  final fullUrl = appService.getFullUrl(endpoint);

    final Uri uri = Uri.parse(fullUrl);
    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'branch_id': globals.branch_id,
          'lens_id': lensId,
          'quantity': lensQty,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['message']); // Optionally update your UI based on the response
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> updateFrameStock(int frameId, int frameQty) async {

  final String endpoint = 'product/update-frame-stock';
  final fullUrl = appService.getFullUrl(endpoint);

    final Uri uri = Uri.parse(fullUrl);
    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'branch_id': globals.branch_id,
          'frame_id': frameId,
          'quantity': frameQty,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['message']); // Or update your UI based on the response
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
