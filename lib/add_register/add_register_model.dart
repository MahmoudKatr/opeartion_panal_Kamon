import 'package:http/http.dart' as http;

Future<String> addregisteremployee({
  required String ssnNumber,
  required String firstName,
  required String lastName,
  required String gender,
  required String salary,
  required String positionId,
  required String status,
  String? branchId,
  String? sectionId,
  required String birthDate,
  required String address,
  String? dateHired,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/employees/employee';
  try {
    // Create a map and add only non-null values
    final Map<String, String> body = {
      'ssn': ssnNumber,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'salary': salary,
      'positionId': positionId,
      'status': status,
      'birthDate': birthDate,
      'address': address,
    };

    if (branchId != null) {
      body['branchId'] = branchId;
    }
    if (sectionId != null) {
      body['sectionId'] = sectionId;
    }
    if (dateHired != null) {
      body['dateHired'] = dateHired;
    }

    final response = await http.post(
      Uri.parse(url),
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final addMenuItem = response
          .body; // Assuming the response body contains the data you need
      print('Status: ${response.statusCode}');
      print('Response: $addMenuItem');
      return addMenuItem;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Failed to add employee: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding employee: $e');
  }
}

Future<String> addPhoneNumber({
  required String ssnNumber,
}) async {
  const url = 'http://192.168.205.1:4000/admin/employees/employee-phone';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'ssn': ssnNumber,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final addMenuItem = response
          .body; // Assuming the response body contains the data you need
      print('Status: ${response.statusCode}');
      print('Response: $addMenuItem');
      return addMenuItem;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Failed to add employee: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding employee: $e');
  }
}
