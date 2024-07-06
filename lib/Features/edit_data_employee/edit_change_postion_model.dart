import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<String> editPositionEmployee({
  required int employee_id,
  required String new_position,
  required String position_change_type,
}) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? employeeId = await secureStorage.read(key: 'employee_id');

  if (employeeId == null) {
    String errorMessage = 'No employee ID found in secure storage.';
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return errorMessage;
  }

  const url = 'https://54.235.40.102.nip.io/admin/employees/change-position';
  try {
    final response = await http.patch(
      Uri.parse(url),
      body: jsonEncode({
        'employee_id': employee_id.toString(),
        'position_changer_id': employeeId,
        'new_position': new_position,
        'position_change_type': position_change_type,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    String message;
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);
      message = jsonResponse['message'] ?? 'Position changed successfully.';
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
      message = jsonResponse['message'] ?? 'Failed to change position.';
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
    return message;
  } catch (e) {
    String errorMessage = 'Error editing employee position: $e';
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return errorMessage;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final result = await editPositionEmployee(
    employee_id: 1,
    new_position: '5',
    position_change_type: 'promote',
  );
  print(result);
}
