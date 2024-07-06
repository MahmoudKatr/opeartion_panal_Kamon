import 'package:http/http.dart' as http;

Future<String> AddGeneral_Section({
  required String sectionName,
  required String sectionDescription,
}) async {
  final url = 'https://54.235.40.102.nip.io/admin/branch/add-general-section';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'section_name': sectionName,
        'section_description': sectionDescription,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final add_menu_item = response
          .body; // Assuming the branchId is returned in the response body
      return add_menu_item;
    } else {
      // Failure
      throw Exception('Failed to add employee: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error add employee: $e');
  }
}
