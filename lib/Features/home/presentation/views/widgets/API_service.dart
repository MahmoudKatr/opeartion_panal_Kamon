import 'package:bloc_v2/Features/home/presentation/views/widgets/login_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Employs?> login(String email, String password) async {
    try {
      final response = await _dio
          .post('https://54.235.40.102.nip.io/admin/employees/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          final token = data['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          return Employs.fromJson(data);
        } else {
          throw Exception(data['message'] ?? 'Login failed');
        }
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
