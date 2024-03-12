import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:optical_desktop/global.dart' as globals; // Import globals library

// Model for Branch Details
class BranchDetail {
  final String branchName;
  final String mobileNumber;
  // final String branchAddress;

  BranchDetail({
    required this.branchName,
    required this.mobileNumber,
    // required this.branchAddress,
  });

  factory BranchDetail.fromJson(Map<String, dynamic> json) {
    return BranchDetail(
      branchName: json['branch_name'],
      mobileNumber: json['mobile_number'],
      // branchAddress: json['branch_address'],
    );
  }
}

///register/branch/{branch_id}

// Function to fetch branch details using the global branch_id
Future<BranchDetail> fetchBranchDetails() async {
  final response = await http.get(Uri.parse('http://172.208.26.215/register/branch/${globals.branch_id}'));

  if (response.statusCode == 200) {
    return BranchDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load branch details');
  }
}
