import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeToggleWidget extends StatelessWidget {
  const ThemeToggleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.lightbulb),
      onPressed: () {
        print('Theme Toggle Button Pressed');
        Get.changeThemeMode(
          Get.theme.brightness == Brightness.dark
              ? ThemeMode.light
              : ThemeMode.dark,
        );
      },
    );
  }
}
