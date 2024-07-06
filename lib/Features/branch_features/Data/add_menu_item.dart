import 'package:http/http.dart' as http;

Future<String> addMenuItem({
  required String itemName,
  required String itemDesc,
  required String categoryID,
  required String prepTime,
  required String picPath,
  required String vegetarian,
  required String healthy,
}) async {
  final url = 'https://54.235.40.102.nip.io/admin/branch/add-menu-item';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'itemName': itemName,
        'itemDesc': itemDesc,
        'categoryID': categoryID,
        'prepTime': prepTime,
        'picPath': picPath,
        'vegetarian': vegetarian,
        'healthy': healthy,
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
      throw Exception('Failed to add menu item: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding menu item: $e');
  }
}
