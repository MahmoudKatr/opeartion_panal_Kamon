import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc_v2/Features/emp_features/presentation/add_position_screen.dart';
import 'package:bloc_v2/add_register/add_register_employee.dart';
import 'package:bloc_v2/app_layout/controllers/app_layout_cubit.dart';

import 'package:bloc_v2/screens/employe_schedule.dart';
import 'package:bloc_v2/screens/employee_vacation.dart';

/// AppLayoutScreen
class PostAppLayout extends StatelessWidget {
  /// AppLayoutScreen constructor
  const PostAppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const AddRegisterEmp(),
      const AddPositionScreen(),
      const AddEmployeeSchedule(),
      const AddEmployeeVacation(),
    ];

    return BlocProvider(
      create: (context) => AppLayoutCubit(),
      child: BlocBuilder<AppLayoutCubit, int>(
        builder: (context, state) {
          return Scaffold(
            body: screens[state],
            bottomNavigationBar: FlashyTabBar(
              selectedIndex: state,
              showElevation: true,
              onItemSelected: (index) =>
                  context.read<AppLayoutCubit>().changeIndex(index),
              items: [
                FlashyTabBarItem(
                  icon: const Icon(Icons.dashboard_sharp),
                  title: const Text('Add Memper'),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.calendar_view_day_rounded),
                  title: const Text('Add Position'),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text('Add Schedule'),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text('Add Vacation'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
