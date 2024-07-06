import 'package:bloc_v2/Features/emp_features/presentation/custom_tool_bar.dart';
import 'package:bloc_v2/Features/emp_features/presentation/get_managers_list.dart';
import 'package:bloc_v2/Features/emp_features/presentation/post_app_layout.dart';
import 'package:bloc_v2/Features/emp_features/presentation/postion_secreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/choose_based_token.dart';
import 'package:bloc_v2/add_register/add_register_employee.dart';
import 'package:bloc_v2/app_layout/controllers/app_layout_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// AppLayoutScreen
class AppLayoutScreen extends StatelessWidget {
  /// AppLayoutScreen constructor
  const AppLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      AllEmployeeScreen(),
      PositionListScreen(),
      ManagersListScreen(),
      const PostAppLayout(),
    ];

    final titles = [
      "Explore",
      "All Positions",
      "All Managers",
      "Staff opeation",
    ];
    final icons = [
      Icons.explore,
      Icons.workspaces,
      Icons.feed,
      Icons.quiz_sharp,
    ];

    return BlocProvider(
      create: (context) => AppLayoutCubit(),
      child: BlocBuilder<AppLayoutCubit, int>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
                title: Text(
                  titles[state], // Update the title based on the current index
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                backgroundColor: Colors.teal),
            backgroundColor: Colors.teal,
            body: Column(
              children: [
                CustomToolBar(
                  titles: titles,
                  icons: icons,
                  callbacks: [
                    () => context.read<AppLayoutCubit>().changeIndex(0),
                    () => context.read<AppLayoutCubit>().changeIndex(1),
                    () => context.read<AppLayoutCubit>().changeIndex(2),
                    () => context.read<AppLayoutCubit>().changeIndex(3),
                  ],
                ),
                Expanded(
                  child: screens[state],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
