import 'package:http/http.dart' as http;

Future<String> addCategoryModel({
  required String sectionId,
  required String categoryName,
  required String categoryDescription,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/menu/category';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'sectionId': sectionId,
        'categoryName': categoryName,
        'categoryDescription': categoryDescription,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final branchId = response.body;
      print('Status: ${response.statusCode}');
      print('Branch added successfully. Category: $branchId');
      return branchId;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Failed to add season: ${response.body}');
      throw Exception('Failed to Category ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding Category: $e');
  }
}
