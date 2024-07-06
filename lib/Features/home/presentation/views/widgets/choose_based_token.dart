import 'package:bloc_v2/Features/branch_features/presentation/cashier_screen.dart';
import 'package:bloc_v2/Features/branch_features/presentation/delivery_screen.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/new_login_screen.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/profile_screen.dart';
import 'package:bloc_v2/Features/operation_manger/app_layout_operation.dart';
import 'package:bloc_v2/app_layout/screens/app_layout_screen.dart';
import 'package:bloc_v2/app_layout_BM/screens/app_layout_screen.dart';
import 'package:bloc_v2/pdf/page/pdf_page.dart';
import 'package:bloc_v2/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../constants.dart';
import 'custom_category_card.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? employeeRole;

  @override
  void initState() {
    super.initState();
    _getEmployeeRole();
  }

  Future<void> _getEmployeeRole() async {
    employeeRole = await secureStorage.read(key: 'employee_role');
    setState(() {});
  }

  Future<void> _logout(BuildContext context) async {
    await secureStorage.delete(key: 'token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreenNew()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.getIsDarkTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamon Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            onPressed: () {
              themeProvider.setDarkTheme(
                  themeValue: !themeProvider.getIsDarkTheme);
            },
            icon: Icon(themeProvider.getIsDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkTheme
                ? [
                    const Color.fromARGB(255, 0, 0, 0),
                    const Color.fromARGB(255, 3, 7, 36),
                  ]
                : [
                    const Color.fromARGB(255, 232, 234, 233),
                    const Color.fromARGB(255, 3, 36, 34)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: employeeRole == null
            ? const Center(child: CircularProgressIndicator())
            : GridView.count(
                crossAxisCount: 2,
                children: _buildCards(context),
              ),
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    switch (employeeRole) {
      case 'manager':
        return _allCards(context);
      case 'hr':
        return [
          _buildCard(context, 'HR Dept', hrImage, const AppLayoutScreen())
        ];
      case 'operation manager':
        return [
          _buildCard(context, 'Operation Manager', operationImage,
              const OpearationMangerLayout())
        ];
      case 'section manager':
        return [
          _buildCard(
              context, 'Branch Manager', mangerImage, const AppLayoutScreenBM())
        ];
      case 'cashier':
        return [
          _buildCard(context, 'Cashier', storgeImage, CashierDeliveryScreen())
        ];
      case 'delivery':
        return [_buildCard(context, 'Delivery', cloud, DeliveryScreen())];
      case 'No Role':
        return [_buildCard(context, 'No Role', table, const ProfileScreen())];
      default:
        return [const Center(child: Text('No Role Defined'))];
    }
  }

  List<Widget> _allCards(BuildContext context) {
    return [
      _buildCard(context, 'HR Dept', hrImage, const AppLayoutScreen()),
      _buildCard(context, 'Operation Manager', operationImage,
          const OpearationMangerLayout()),
      _buildCard(
          context, 'Branch Manager', mangerImage, const AppLayoutScreenBM()),
      _buildCard(context, 'Cashier', storgeImage, CashierDeliveryScreen()),
      _buildCard(context, 'Delivery', cloud, DeliveryScreen()),
      _buildCard(context, 'No Role', table, const ProfileScreen()),
    ];
  }

  Widget _buildCard(BuildContext context, String text, String photoUrl,
      Widget destinationScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: CustomCard(
        text: text,
        photoUrl: photoUrl,
      ),
    );
  }
}
