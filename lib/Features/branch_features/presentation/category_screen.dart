import 'package:bloc_v2/Drawer/customDrawer.dart';
import 'package:bloc_v2/Features/branch_features/Data/get_all_OM_function.dart';
import 'package:bloc_v2/Features/branch_features/models/OM_function_model.dart';
import 'package:bloc_v2/Features/branch_features/presentation/custom_category_Card.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<CategoryModel>>(
        future: GetCategories().getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<CategoryModel> CategoryItem = snapshot.data!;
            return ListView.builder(
              itemCount: CategoryItem.length,
              itemBuilder: (context, index) {
                return CustomCategoryCard(CategoryItem: CategoryItem[index]);
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
