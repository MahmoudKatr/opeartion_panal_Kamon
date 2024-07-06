import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> AddPhoneNumberEmployee({
  required int employeeId,
  required String employeePhone,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/employees/employee-phone';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'employeeId': employeeId.toString(), // Fixed parameter name
        'employeePhone': employeePhone,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        final data = jsonResponse['data'];
        print('Data: $data');
        return {'status': 'success', 'data': data};
      } else {
        return {
          'status': 'error',
          'message': 'Unexpected success response format'
        };
      }
    } else {
      // Failure
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message'] ?? 'Unknown error';
      print(
          'Failed to add employee phone. Status code: ${response.statusCode}, Message: $message');
      return {'status': 'error', 'message': message};
    }
  } catch (e) {
    print('Error adding employee phone: $e');
    return {'status': 'error', 'message': e.toString()};
  }
}

void main() async {
  final result = await AddPhoneNumberEmployee(
    employeeId: 1,
    employeePhone: '01117871340',
  );
  print(result);
}
