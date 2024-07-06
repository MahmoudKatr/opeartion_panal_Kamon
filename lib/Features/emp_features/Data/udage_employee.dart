

import '../../../core/utils/helper/api_helper.dart';
import '../models/product_model.dart';

class UpdateEmployee {
  Future<EmployeeModel> updateEmployee(
      {required String title,
       // required String price,
        required String description,
        required String category,
        required String image,
      required int id,
      }) async {
    print('emp id = $id');

    Map<String, dynamic> data =
    await ApiHelper().put(url: 'https://fakestoreapi.com/products/:idhttps://fakestoreapi.com/products/$id', body: {
      'title': title,
      //'price': price,
      'description': description,
      'image': image,
      'category': category,
    });
    return EmployeeModel.fromJson(data);
  }


}