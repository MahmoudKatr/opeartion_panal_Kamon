import 'package:bloc_v2/Features/branch_features/presentation/all_braches_screen.dart';
import 'package:bloc_v2/Features/branch_features/presentation/category_screen.dart';
import 'package:bloc_v2/Features/branch_features/presentation/recipes_screeen.dart';
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

import 'custom_bar_OM.dart';

/// AppLayoutScreen
class GetAppLayoutScreenOperation extends StatelessWidget {
  /// AppLayoutScreen constructor
  const GetAppLayoutScreenOperation({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      AllBranchScreen(),
      CategoryScreen(),
      RecipesList(
        2,
        iD: 2,
      ),
    ];

    final titles = [
      "All Branches",
      "Kitchen Category",
      "Recipe Item",
    ];
    final icons = [
      Icons.home,
      Icons.category,
      Icons.food_bank,
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
                    color: Colors.white,
                  ),
                ),
              ),
              backgroundColor:
                  Colors.blue, // Change this to your preferred color
            ),
            backgroundColor:
                const Color.fromARGB(255, 75, 72, 72), // Dark background color
            body: Column(
              children: [
                CustomToolBarOM(
                  titles: titles,
                  icons: icons,
                  callbacks: [
                    () => context.read<AppLayoutCubit>().changeIndex(0),
                    () => context.read<AppLayoutCubit>().changeIndex(1),
                    () => context.read<AppLayoutCubit>().changeIndex(2),
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
