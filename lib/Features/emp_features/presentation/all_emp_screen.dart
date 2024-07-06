import 'package:bloc_v2/Features/emp_features/Data/get_active_emp.dart';
import 'package:bloc_v2/Features/emp_features/models/active_emp_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:bloc_v2/providers/theme_provider.dart';
import 'dart:async';
import 'custom_card.dart';

class AllEmployeeScreen extends StatefulWidget {
  @override
  _AllEmployeeScreenState createState() => _AllEmployeeScreenState();
}

class _AllEmployeeScreenState extends State<AllEmployeeScreen> {
  bool _showSearch = false;
  bool _isSearching = false;
  int _selectedIndex = 0;
  final _searchTextController = TextEditingController();
  List<ActiveEmployeesModel> searchedForEmployeeList = [];
  List<ActiveEmployeesModel> allEmployeeList = [];
  bool _isShowingActive = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchTextController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchEmployees();
    });

    Future.delayed(const Duration(seconds: 1), () {
      _timer?.cancel();
    });
  }

  void _fetchEmployees() {
    // Replace with your actual data fetching logic
    setState(() {});
  }

  void toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  void addSearchedForItemsToSearchedList(String searchedCharacter) {
    searchedForEmployeeList = allEmployeeList
        .where((activeEmployee) => activeEmployee.employeeName
            .toLowerCase()
            .startsWith(searchedCharacter.toLowerCase()))
        .toList();
    setState(() {});
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  void _toggleEmployeeStatus() {
    setState(() {
      _isShowingActive = !_isShowingActive;
    });
  }

  Widget NoInternetWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/undraw_bug_fixing_oc7a.png',
                  height: 200),
              const SizedBox(height: 40),
              const Text(
                'Oops! No Internet Connection.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Please check your network settings and try again.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Retry action
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        if (connected) {
          return Scaffold(
            backgroundColor:
                themeProvider.getIsDarkTheme ? Colors.black : Colors.white,
            body: Column(
              children: [
                const SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchTextController,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: _searchTextController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.grey),
                                    onPressed: () {
                                      _clearSearch();
                                    },
                                  )
                                : null,
                            hintText: 'Search employees..',
                            hintStyle: const TextStyle(color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                            ),
                          ),
                          onChanged: (searchedCharacter) {
                            addSearchedForItemsToSearchedList(
                                searchedCharacter);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Staff',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _toggleEmployeeStatus,
                        icon:
                            const Icon(Icons.filter_list, color: Colors.white),
                        label: Text(
                          _isShowingActive ? 'Show Inactive' : 'Show Active',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<ActiveEmployeesModel>>(
                    future: _isShowingActive
                        ? GetActiveEmployee().fetchActiveEmployees()
                        : GeIntActiveEmployee()
                            .geIntActiveEmployee(), // Assuming a similar function for inactive employees
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        allEmployeeList = snapshot.data!;
                        List<ActiveEmployeesModel> employeesToShow =
                            _searchTextController.text.isEmpty
                                ? allEmployeeList
                                : searchedForEmployeeList;

                        return ListView.builder(
                          itemCount: employeesToShow.length,
                          itemBuilder: (context, index) {
                            return CustomCard(
                              activeEmployee: employeesToShow[index],
                              startPolling: _startPolling,
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return NoInternetWidget();
        }
      },
      child: const Text('No internet connection'),
    );
  }
}
