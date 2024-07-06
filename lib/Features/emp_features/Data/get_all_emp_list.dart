import '../models/product_model.dart';
import '../../../core/utils/helper/api_helper.dart';

class GetAllEmployee {
  Future<List<EmployeeModel>> getAllProduct() async {
    List<dynamic> data = await ApiHelper().get(url: "https://fakestoreapi.com/products");
      List<EmployeeModel>emplyeeList = [];
      for (int i=0;i<data.length;i++)
      {
        emplyeeList.add(EmployeeModel.fromJson(data[i]));
      }
      return emplyeeList;

  }
}
