import 'dart:convert';
import 'package:http/http.dart' as http;

class Branch {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String createdDate;
  final double latitude;
  final double longitude;
  final int coverage;
  final String managerName;
  final int managerId;
  final String tables;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.createdDate,
    required this.latitude,
    required this.longitude,
    required this.coverage,
    required this.managerName,
    required this.managerId,
    required this.tables,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['fn_branch_id'],
      name: json['fn_branch_name'],
      address: json['fn_branch_address'],
      phone: json['fn_branch_phone'],
      createdDate: json['fn_branch_created_date'],
      latitude: json['fn_location_coordinates']['x'],
      longitude: json['fn_location_coordinates']['y'],
      coverage: json['fn_coverage'],
      managerName: json['fn_manager_name'],
      managerId: json['fn_manager_id'],
      tables: json['fn_branch_tables'],
    );
  }
}

class BranchComparison {
  final int branchId;
  final String branchName;
  final double totalSales;
  final int totalOrders;

  BranchComparison({
    required this.branchId,
    required this.branchName,
    required this.totalSales,
    required this.totalOrders,
  });

  factory BranchComparison.fromJson(Map<String, dynamic> json) {
    return BranchComparison(
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      totalSales: double.parse(json['total_sales']),
      totalOrders: int.parse(json['total_orders']),
    );
  }
}

// Fetch branch details function
Future<Branch> fetchBranchDetails(int branchId) async {
  final response = await http.get(
      Uri.parse('https://54.235.40.102.nip.io/admin/branch/branches?branchId=$branchId'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return Branch.fromJson(jsonResponse['data'][0]);
  } else {
    throw Exception('Failed to load branch details');
  }
}

// Fetch branch comparison function
Future<List<BranchComparison>> fetchBranchComparison(int days) async {
  final response = await http.get(
      Uri.parse('https://54.235.40.102.nip.io/admin/branch/branchesCompare/$days'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final List<dynamic> data = jsonResponse['data'];
    return data.map((json) => BranchComparison.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load branch comparison data');
  }
}

// Utility function to extract date only from datetime string
String extractDate(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime);
  return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
}
