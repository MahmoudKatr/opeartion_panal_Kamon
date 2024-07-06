import 'package:flutter/material.dart';
import 'drawerItemModel.dart';
class CustomDrwerItem extends StatelessWidget {
  const CustomDrwerItem({super.key, required this.drawerItemModel});

  final DrawerItemModel drawerItemModel;
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading: Icon(
          drawerItemModel.icon,
      ),
      title: Text(drawerItemModel.title),

    );
  }
}
