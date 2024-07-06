import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  late Future<List<Map<String, String>>> _futureSchedule;

  @override
  void initState() {
    super.initState();
    _futureSchedule = fetchSchedule();
  }

  Future<List<Map<String, String>>> fetchSchedule() async {
    String? branchId = await secureStorage.read(key: 'employee_branch_id');

    // Calculate the current date and the date 15 days ago
    final DateTime now = DateTime.now();
    final DateTime fromDate = now.subtract(Duration(days: 15));

    // Format the dates to strings
    final String formattedNow = DateFormat('yyyy-MM-dd').format(now);
    final String formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);

    final response = await http.get(
      Uri.parse(
          'https://54.235.40.102.nip.io/admin/branch/employeesSchedule/$branchId?fromDate=$formattedFromDate&toDate=$formattedNow'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data']['attendance'] != null) {
        List<Map<String, String>> schedule =
            (data['data']['attendance'] as List).map((item) {
          return {
            "employee": item['employee'] as String,
            "shift_start_time": item['shift_start_time'] as String,
            "shift_end_time": item['shift_end_time'] as String,
          };
        }).toList();
        return schedule;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Schedule',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue[800],
        centerTitle: true,
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, String>>>(
          future: _futureSchedule,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Schedule'));
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Employee')),
                    DataColumn(label: Text('Shift Start Time')),
                    DataColumn(label: Text('Shift End Time')),
                  ],
                  rows: snapshot.data!.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['employee']!,
                          style: TextStyle(fontSize: 16))),
                      DataCell(formatDateTime(item['shift_start_time']!)),
                      DataCell(formatDateTime(item['shift_end_time']!)),
                    ]);
                  }).toList(),
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.lightBlue[800]!),
                  dataRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.lightBlue[100]!),
                  dataTextStyle: TextStyle(color: Colors.black, fontSize: 16),
                  headingTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  columnSpacing: 20,
                  dividerThickness: 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.lightBlue[800]!),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget formatDateTime(String dateTime) {
    final DateTime parsedDateTime = DateTime.parse(dateTime);
    final String formattedDate =
        DateFormat('yyyy-MM-dd').format(parsedDateTime);
    final String formattedTime = DateFormat('HH:mm').format(parsedDateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formattedDate,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(formattedTime, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
