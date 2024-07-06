import 'package:bloc_v2/Features/emp_features/models/product_model.dart';
import 'package:bloc_v2/core/utils/helper/api_helper.dart';

class AddEmployee {
  Future<EmployeeModel> addEmployee(
      {required String title,
      required String price,
      required String description,
      required String category,
      required String image}) async {
    Map<String, dynamic> data =
        await ApiHelper().post(url: 'https://fakestoreapi.com/products', body: {
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'category': category,
    });
    return EmployeeModel.fromJson(data);
  }
}
