import 'package:bloc_v2/Features/branch_features/models/employeesAttendance_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting

class GetEmpAtndance {
  Future<List<EmployeesAttendanceModel>> getEmpAtndance({
    required String branch_id,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    // Formatter to convert DateTime to the required string format
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedFromDate = formatter.format(fromDate);
    String formattedToDate = formatter.format(toDate);

    final String url =
        'http://ec2-13-37-245-245.eu-west-3.compute.amazonaws.com:4000/admin/branch/employeesAttendance/$branch_id?fromDate=$formattedFromDate&toDate=$formattedToDate';
    print('URL: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'success' &&
          jsonResponse['data']['attendance'] is List) {
        List<dynamic> employeesData = jsonResponse['data']['attendance'];
        return employeesData
            .map((data) => EmployeesAttendanceModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load active employees data');
      }
    } else {
      throw Exception('Failed to retrieve data');
    }
  }
}
