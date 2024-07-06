import 'package:bloc_v2/Features/branch_features/models/OM_function_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetCategories {
  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(
        Uri.parse('https://54.235.40.102.nip.io/admin/branch/categories-list'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {
        List<dynamic> employeesData = jsonResponse['data'];
        return employeesData
            .map((data) => CategoryModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load active employees data');
      }
    } else {
      throw Exception('Failed to retrieve data');
    }
  }
}

class GetSection {
  Future<List<SectionModel>> getSection({required int branchID}) async {
    final response = await http.get(
        Uri.parse('https://54.235.40.102.nip.io/admin/branch/sections/$branchID'));

    print('Server response: ${response.body}');

    if (response.statusCode == 200) {
      try {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] is Map &&
            jsonResponse['data']['sections'] is List) {
          List<dynamic> data = jsonResponse['data']['sections'];
          return data.map((item) => SectionModel.fromJson(item)).toList();
        } else {
          throw Exception('Data is not in the expected format');
        }
      } catch (e) {
        print('Parsing error: $e');
        throw Exception('Failed to parse data');
      }
    } else {
      throw Exception(
          'Failed to retrieve data with status code: ${response.statusCode}');
    }
  }
}
