import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<void> editTransferEmployee({
  required int employeeId,
  required String branchId,
  String? transferReason,
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

  const url = 'https://54.235.40.102.nip.io/admin/employees/employeeTransfer';

  try {
    final requestBody = {
      'employeeId': employeeId.toString(),
      'branchId': branchId,
      'transferMadeBy': changerId,
      if (transferReason != null) 'transferReason': transferReason,
    };

    print('Request Body: $requestBody'); // Debug log

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message'];
    } else {
      // Failure
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message']; // Extract the message
    }
  } catch (e) {
    print('Error: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await editTransferEmployee(
    employeeId: 1,
    branchId: '1',
    transferReason: 'not working well', // optional
  );
}
