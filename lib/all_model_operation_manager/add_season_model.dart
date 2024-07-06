import 'package:http/http.dart' as http;

Future<String> addSeasonModel({
  required String seasonName,
  required String seasonDesc,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/menu/season';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'seasonName': seasonName,
        'seasonDesc': seasonDesc,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final branchId = response.body;
      print('Status: ${response.statusCode}');
      print('Branch added successfully. season: $branchId');
      return branchId;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Failed to add season: ${response.body}');
      throw Exception('Failed to season ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding season: $e');
  }
}
