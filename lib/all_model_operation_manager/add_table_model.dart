import 'package:http/http.dart' as http;

Future<String> addTableModel(
    {required String branchId,
    required String capacity,
    required String status}) async {
  const url = 'https://54.235.40.102.nip.io/admin/table/add-newTable';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {'branchId': branchId, 'capacity': capacity, 'status': status},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final branchId = response.body;
      print('Status: ${response.statusCode}');
      print('Branch added successfully. Table: $branchId');
      return branchId;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Failed to add branch: ${response.body}');
      throw Exception('Failed to add Table: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding Table: $e');
  }
}
