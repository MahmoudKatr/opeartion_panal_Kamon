import '../models/branch_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetAllBranches {
  Future<List<BranchModel>> getAllBranches() async {
    final response = await http
        .get(Uri.parse('https://54.235.40.102.nip.io/admin/branch/branches-list'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success') {
        List<dynamic> employeesData = jsonResponse['data'];
        return employeesData.map((data) => BranchModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load active employees data');
      }
    } else {
      throw Exception('Failed to retrieve data');
    }
  }
}


//http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/branch/branches-list
//getAllBranches