import 'package:bloc_v2/core/utils/helper/api_helper.dart';

class AllDepartmentService
{

  Future<List<dynamic>> getAllDepartment() async
  {
    List<dynamic> data = await ApiHelper().get(url: 'https://fakestoreapi.com/products/categories');

  return data;
  }
}