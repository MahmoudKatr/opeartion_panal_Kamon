import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'get_employee_by_ID_model.dart'; // Import the Employee model file
import 'package:bloc_v2/providers/theme_provider.dart';

class TableSreen extends StatefulWidget {
  const TableSreen({super.key});

  @override
  State<TableSreen> createState() => _TableSreenState();
}

class _TableSreenState extends State<TableSreen> {
  late Future<List<Employee>> futureEmployees;

  @override
  void initState() {
    super.initState();
    futureEmployees = fetchEmployees();
  }

  Future<void> sendTimeInAttendance(int employeeId) async {
    final response = await http.post(
      Uri.parse('https://54.235.40.102.nip.io/admin/employees/timeInAttendance'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'employeeId': employeeId,
      }),
    );

    if (response.statusCode == 200) {
      _showDialog(
          'Success', 'Time in attendance successfully sent.', Colors.teal);
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String errorMessage =
          responseData['message'] ?? 'Unknown error occurred';
      _showDialog('Error', 'Failed to send time in attendance: $errorMessage',
          Colors.redAccent);
    }
  }

  Future<void> sendTimeOutAttendance(int employeeId) async {
    final response = await http.post(
      Uri.parse('https://54.235.40.102.nip.io/admin/employees/timeOutAttendance'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'employeeId': employeeId,
      }),
    );

    if (response.statusCode == 200) {
      _showDialog(
          'Success', 'Time out attendance successfully sent.', Colors.teal);
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String errorMessage =
          responseData['message'] ?? 'Unknown error occurred';
      _showDialog('Error', 'Failed to send time out attendance: $errorMessage',
          Colors.redAccent);
    }
  }

  void _showDialog(String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title,
              style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: GoogleFonts.openSans(color: color)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDarkTheme = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<List<Employee>>(
        future: futureEmployees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final employee = snapshot.data![index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_downward, color: Colors.redAccent),
                      onPressed: () {
                        sendTimeOutAttendance(employee.employeeId);
                      },
                    ),
                    title: Center(
                      child: Text(
                        '${employee.firstName} ${employee.lastName}',
                        style: GoogleFonts.openSans(
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_upward, color: Colors.teal),
                      onPressed: () {
                        sendTimeInAttendance(employee.employeeId);
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
