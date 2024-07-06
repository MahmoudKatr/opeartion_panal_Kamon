import 'package:bloc_v2/Features/emp_features/presentation/add_position_screen.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class sideBarHR extends StatelessWidget {
  const sideBarHR({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: SidebarXController(selectedIndex: 0),
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home', // Remove the extra comma here
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPositionScreen(),
              ),
            );
          },
        ),
        SidebarXItem(icon: Icons.search, label: 'Search'),
      ],
    );
  }
}
