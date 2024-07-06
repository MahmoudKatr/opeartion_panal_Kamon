import 'package:bloc_v2/app_layout/controllers/app_layout_cubit.dart';
import 'package:bloc_v2/app_layout_BM/screens/BM_get_layout_screen.dart';
import 'package:bloc_v2/app_layout_BM/screens/BM_opeartion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';

/// AppLayoutScreen
class AppLayoutScreenBM extends StatelessWidget {
  /// AppLayoutScreen constructor
  const AppLayoutScreenBM({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      BranchMangerOpeartion(),
      const AppLayoutScreenBMGET(),
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
                  title: const Text('Operation'),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.calendar_view_day_rounded),
                  title: const Text('Branch State'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
