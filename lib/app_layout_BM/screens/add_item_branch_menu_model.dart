import 'package:http/http.dart' as http;

Future<String> addItemBranchMenu({
  required String branchId,
  required String itemId,
  required String itemPrice,
  required String itemStatus,
  required String itemDiscount,
}) async {
  final url = 'https://54.235.40.102.nip.io/admin/branch/addItemBranchMenu';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'branchId': branchId,
        'itemId': itemId,
        'itemPrice': itemPrice,
        'itemStatus': itemStatus,
        'itemDiscount': itemDiscount,
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
      throw Exception('Failed to add employee: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding employee: $e');
  }
}
