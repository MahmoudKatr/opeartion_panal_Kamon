import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> editAddressEmployee({
  required int employeeId,
  required String newAddress,
}) async {
  const url =
      'https://54.235.40.102.nip.io/admin/employees/update-employee-address';
  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'employeeId': employeeId.toString(),
        'newAddress': newAddress,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        final data = jsonResponse['data'] as List;
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
          'Failed to edit employee phone. Status code: ${response.statusCode}, Message: $message');
      return {'status': 'error', 'message': message};
    }
  } catch (e) {
    print('Error editing employee phone: $e');
    return {'status': 'error', 'message': e.toString()};
  }
}

void main() async {
  final result = await editAddressEmployee(
    employeeId: 1,
    newAddress: 'adfasfasdf',
  );
  print(result);
}
