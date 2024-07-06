import 'package:http/http.dart' as http;

Future<String> addStorageModel({
  required String storageName,
  required String storageAddress,
  required String managerId,
}) async {
  final url = 'https://54.235.40.102.nip.io/admin/branch/add-storage';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'storageName': storageName,
        'storageAddress': storageAddress,
        'managerId': managerId,
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
      throw Exception('Failed to add storge: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding storge: $e');
  }
}
