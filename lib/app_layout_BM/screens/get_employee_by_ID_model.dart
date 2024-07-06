import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Employee {
  final int employeeId; // Changed to int
  final String firstName;
  final String lastName;

  Employee(
      {required this.employeeId,
      required this.firstName,
      required this.lastName});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId:
          json['fn_employee_id'] ?? 0, // Provide a default value if null
      firstName: json['fn_employee_first_name'] ?? '',
      lastName: json['fn_employee_last_name'] ?? '',
    );
  }
}

final FlutterSecureStorage secureStorage = FlutterSecureStorage();
// Function to fetch employees
Future<List<Employee>> fetchEmployees() async {
  String? branchId = await secureStorage.read(key: 'employee_branch_id');

  final response = await http.get(Uri.parse(
      'https://54.235.40.102.nip.io/admin/employees/employeeData?branchId=$branchId&status=active'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body)['data'];
    return data.map((json) => Employee.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load employees');
  }
}
