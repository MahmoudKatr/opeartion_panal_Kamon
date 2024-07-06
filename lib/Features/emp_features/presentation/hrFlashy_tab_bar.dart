import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/add_register/add_register_employee.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:bloc_v2/Features/emp_features/presentation/add_position_screen.dart';

class HrFlashyTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  HrFlashyTabBar({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static final List<FlashyTabBarItemData> tabItems = [
    FlashyTabBarItemData(
      icon: const Icon(Icons.event),
      title: const Text('View state'),
      screen: AllEmployeeScreen(),
    ),
    FlashyTabBarItemData(
      icon: const Icon(Icons.add),
      title: const Text('Add & Edit'),
      screen: const AddPositionScreen(),
    ),
    FlashyTabBarItemData(
      icon: const Icon(Icons.settings),
      title: const Text('Settings'),
      screen: const AddPositionScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlashyTabBar(
      selectedIndex: selectedIndex,
      onItemSelected: onItemSelected,
      items: tabItems.map((tabItem) {
        return FlashyTabBarItem(
          icon: tabItem.icon,
          title: tabItem.title,
        );
      }).toList(),
    );
  }
}

class FlashyTabBarItemData {
  final Icon icon;
  final Text title;
  final Widget screen;

  FlashyTabBarItemData({
    required this.icon,
    required this.title,
    required this.screen,
  });
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children:
            HrFlashyTabBar.tabItems.map((tabItem) => tabItem.screen).toList(),
      ),
      bottomNavigationBar: HrFlashyTabBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onTabSelected,
      ),
    );
  }
}
