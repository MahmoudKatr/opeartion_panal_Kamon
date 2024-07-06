import 'package:http/http.dart' as http;

Future<String> editChangeStatusModel({
  required String employeeId,
  required String employeeStatus,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/employees/employeeStatusChange';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'employeeId': employeeId,
        'employeeStatus': employeeStatus,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final addMenuItem = response
          .body; // Assuming the response body contains the data you need
      print('Status: ${response.statusCode}');
      return addMenuItem;
    } else {
      print('Status: ${response.statusCode}');
      throw Exception('Failed to edit Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error edit Status: $e');
  }
}
