import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<void> editSalaryEmployee({
  required int employeeId,
  required String newSalary,
  required String changeReason,
}) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? storedChangerId = await secureStorage.read(key: 'employee_id');

  const url = 'https://54.235.40.102.nip.io/admin/employees/change-salary';
  try {
    final response = await http.patch(
      Uri.parse(url),
      body: {
        'employeeId': employeeId.toString(),
        'changerId': storedChangerId,
        'newSalary': newSalary,
        'changeReason': changeReason,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message'] ??
          'Salary change successful'; // Extract the message
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      // Failure
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message'] ??
          'Failed to change salary'; // Extract the message
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } catch (e) {
    print('Error: $e');
    Fluttertoast.showToast(
      msg: 'An error occurred: $e',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

void main() {
  // Ensure the app is properly initialized before calling the function
  WidgetsFlutterBinding.ensureInitialized();

  editSalaryEmployee(
    employeeId: 1,
    newSalary: '1000',
    changeReason: 'Performance bonus',
  );
}
