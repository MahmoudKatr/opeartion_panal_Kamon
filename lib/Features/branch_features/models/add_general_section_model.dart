import 'package:http/http.dart' as http;

Future<String> addGeneralSectionModel({
  required String branch_id,
  required String section_id,
  required String manager_id,
}) async {
  final url = 'https://54.235.40.102.nip.io/admin/branch/add-branch-section';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'branch_id': branch_id,
        'section_id': section_id,
        'manager_id': manager_id,
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
      throw Exception('Failed to add branch section: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding branch section: $e');
  }
}
