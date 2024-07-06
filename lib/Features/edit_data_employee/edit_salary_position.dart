import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<void> editSalaryAndPositionEmployee({
  required int employeeId,
  required String newSalary,
  required String newPosition,
  required String positionChangeType,
  required String changeReason,
}) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? changerId = await secureStorage.read(key: 'employee_id');

  if (changerId == null) {
    Fluttertoast.showToast(
      msg: 'Changer ID not found in secure storage.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return;
  }

  const url =
      'https://54.235.40.102.nip.io/admin/employees/updateEmployeeSalaryPosition';

  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'employeeId': employeeId.toString(),
        'changerId': changerId,
        'newSalary': newSalary,
        'newPosition': newPosition,
        'positionChangeType': positionChangeType,
        'changeReason': changeReason,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message']; // Extract the message
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
      String message = jsonResponse['message']; // Extract the message
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await editSalaryAndPositionEmployee(
    employeeId: 1,
    newSalary: '1000',
    newPosition: 'asdfasdf',
    positionChangeType: 'asdfasdf',
    changeReason: 'asdfasdf',
  );
}
