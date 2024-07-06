import 'dart:convert';
import 'package:bloc_v2/Features/emp_features/models/positon_models.dart';
import 'package:http/http.dart' as http;

Future<List<PositionModel>> fetchPositions() async {
  final response = await http.get(
    Uri.parse(
        'https://54.235.40.102.nip.io/admin/employees/positions-list'), // Replace with your actual API endpoint
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> positionsJson = jsonData[
        'data']; // Adjust this key based on the actual API response structure
    return positionsJson.map((item) => PositionModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load positions');
  }
}
