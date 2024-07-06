import 'package:http/http.dart' as http;

Future<String> addBranchModel({
  required String branchName,
  required String branchAddress,
  required String branchLocation,
  required String coverage,
  required String branchPhone,
  required String manager_id,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/branch/add-new';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'branchName': branchName,
        'branchAddress': branchAddress,
        'branchLocation': branchLocation,
        'coverage': coverage,
        'branchPhone': branchPhone,
        'manager_id': manager_id
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final branchId = response.body;
      return branchId;
    } else {
      // Failure
      throw Exception('Failed to add branch: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error adding branch: $e');
  }
}
