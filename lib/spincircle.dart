import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
import 'spincircle2.dart';
import 'Features/emp_features/presentation/add_position_screen.dart';

class Spincircle extends StatefulWidget {
  @override
  _SpincircleState createState() => _SpincircleState();
}

class _SpincircleState extends State<Spincircle> {
  @override
  Widget build(BuildContext context) {
    return HrNavBar();
  }

  Scaffold HrNavBar() {
    return Scaffold(
      body: SpinCircleBottomBarHolder(
        bottomNavigationBar: SCBottomBarDetails(
          items: [
            SCBottomBarItem(
                icon: Iconsax.home,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SpincircleAll()));
                }),
            SCBottomBarItem(
                icon: Icons.person_2_outlined,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Spincircle()));
                }),
            SCBottomBarItem(icon: Iconsax.logout, onPressed: () {}),
            SCBottomBarItem(icon: Icons.settings, onPressed: () {}),
          ],
          circleItems: [
            SCItem(icon: const Icon(Icons.person_add_alt), onPressed: () {}),
            SCItem(
                icon: const Icon(Icons.workspace_premium_rounded),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPositionScreen()));
                }),
          ],
          circleColors: [
            Colors.black,
            Colors.white,
            Colors.orange,
          ],
          iconTheme: const IconThemeData(color: Colors.black45),
          activeIconTheme:
              const IconThemeData(color: Color.fromARGB(115, 196, 196, 216)),
          titleStyle: const TextStyle(
              color: Color.fromARGB(115, 196, 196, 216), fontSize: 12),
          activeTitleStyle: const TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        child: Center(child: Text('Hi')),
      ),
    );
  }
}