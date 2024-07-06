import 'package:bloc_v2/Features/emp_features/models/product_model.dart';
import 'package:bloc_v2/core/utils/helper/api_helper.dart';


class DepartmentService
{
  Future<List<EmployeeModel>> getDepartmentServices ({required String departmentName})async
  {
 List<dynamic> data = await ApiHelper().get(url: "https://fakestoreapi.com/products/category/${departmentName}");

    List<EmployeeModel>emplyeeList = [];
    for (int i=0;i<data.length;i++)
    {
    emplyeeList.add(EmployeeModel.fromJson(data[i]));
    }
    return emplyeeList;
  
}
}