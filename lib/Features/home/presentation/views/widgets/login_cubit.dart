import 'package:bloc/bloc.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/login_resopnse.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../../core/error/failure.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Dio dio;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  LoginCubit(this.dio) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final response = await dio.post(
        'https://54.235.40.102.nip.io/admin/employees/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        // Store the token securely
        await secureStorage.write(key: 'token', value: loginResponse.token);

        // Decode the token and store data securely
        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(loginResponse.token);
        await secureStorage.write(
            key: 'employee_id', value: decodedToken['employee_id'].toString());
        await secureStorage.write(
            key: 'employee_first_name',
            value: decodedToken['employee_first_name']);
        await secureStorage.write(
            key: 'employee_last_name',
            value: decodedToken['employee_last_name']);
        await secureStorage.write(
            key: 'employee_status', value: decodedToken['employee_status']);
        await secureStorage.write(
            key: 'employee_position', value: decodedToken['employee_position']);
        await secureStorage.write(
            key: 'employee_role', value: decodedToken['employee_role']);
        await secureStorage.write(
            key: 'employee_branch_name',
            value: decodedToken['employee_branch_name']);
        await secureStorage.write(
            key: 'employee_branch_id',
            value: decodedToken['employee_branch_id'].toString());
        await secureStorage.write(
            key: 'branch_section_id',
            value: decodedToken['branch_section_id'].toString());
        await secureStorage.write(
            key: 'section_name', value: decodedToken['section_name']);
        await secureStorage.write(
            key: 'picture_path', value: decodedToken['picture_path']);

        // Calculate token expiration and store it
        DateTime expirationDate =
            JwtDecoder.getExpirationDate(loginResponse.token);
        await secureStorage.write(
            key: 'token_expiration',
            value: expirationDate.millisecondsSinceEpoch.toString());

        emit(LoginSuccess(loginResponse));
      } else {
        emit(LoginFailure(
            ServerFailure.fromResponse(response.statusCode, response.data)));
      }
    } on DioException catch (e) {
      emit(LoginFailure(ServerFailure.fromDioError(e)));
    } catch (e) {
      emit(LoginFailure(ServerFailure(e.toString())));
    }
  }
}
