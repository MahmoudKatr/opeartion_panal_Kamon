import 'package:http/http.dart' as http;

Future<String> ModelEmployeeVacation({
  required String employeeId,
  required String vacationStartDate,
  required String vacationEndDate,
  required String vacationReason,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/employees/employee-vacation';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'employeeId': employeeId,
        'vacationStartDate': vacationStartDate,
        'vacationEndDate': vacationEndDate,
        'vacationReason': vacationReason,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final addMenuItem = response
          .body; // Assuming the response body contains the data you need
      print('Status: ${response.statusCode}');
      print('Response: $addMenuItem');
      return addMenuItem;
    } else {
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Failed to add vacation: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding vacation: $e');
  }
}
