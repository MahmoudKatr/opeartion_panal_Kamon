import 'package:http/http.dart' as http;

Future<String> addRecipeModel({
  required String itemId,
  required String quantity,
  required String recipeStatus,
  required String ingredientId,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/menu/recipe';
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'itemId': itemId,
        'ingredientId': ingredientId,
        'quantity': quantity,
        'recipeStatus': recipeStatus
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
      print('Failed to add Recipe: ${response.body}');
      throw Exception('Failed to add Recipe: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding Recipe: $e');
  }
}
