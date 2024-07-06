import 'package:http/http.dart' as http;

Future<String> addItemByTime({
  required String itemId,
  required String itemDayType,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/menu/itemByTime';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'itemId': itemId,
        'itemDayType': itemDayType,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final branchId = response.body;
      print('Status: ${response.statusCode}');
      print('Branch added successfully. Branch ID: $branchId');
      return branchId;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Failed to add Item by Time: ${response.body}');
      throw Exception('Failed to add Item by Time: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding Item by Time: $e');
  }
}
