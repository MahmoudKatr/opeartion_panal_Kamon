import 'package:http/http.dart' as http;
Future<String> addTableModel({
  required String branchId,
  required String capacity,
  required String status,
}) async {
  final url = 'http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/table/add-newTable';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'branchId': branchId,
        'capacity': capacity,
        'status': status,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final add_menu_item = response.body; // Assuming the branchId is returned in the response body
      return add_menu_item;
    } else {
      // Failure
      throw Exception('Failed to Add Table: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error Add Table: $e');
  }
}
