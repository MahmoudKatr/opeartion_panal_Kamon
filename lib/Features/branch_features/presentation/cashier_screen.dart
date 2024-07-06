import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CashierDeliveryScreen extends StatefulWidget {
  @override
  _CashierDeliveryScreenState createState() => _CashierDeliveryScreenState();
}

class _CashierDeliveryScreenState extends State<CashierDeliveryScreen> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  List<dynamic> deliveryOrders = [];
  List<dynamic> employees = [];
  Map<String, String> selectedEmployees = {};
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchDeliveryOrders();
    fetchEmployees();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchDeliveryOrders();
      fetchEmployees();
    });
  }

  Future<void> fetchDeliveryOrders() async {
    String? branchId = await secureStorage.read(key: 'employee_branch_id');
    if (branchId != null) {
      final response = await http.get(
        Uri.parse(
            'https://54.235.40.102.nip.io/user/delivery/deliveryOrders?orderType=delivery&branchId=$branchId&inDeliveredOrders=false'),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            deliveryOrders = json.decode(response.body)['data'];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        throw Exception('Failed to load delivery orders');
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      throw Exception('Failed to retrieve branch ID');
    }
  }

  Future<void> fetchEmployees() async {
    String? branchId = await secureStorage.read(key: 'employee_branch_id');
    if (branchId != null) {
      try {
        final response = await http.get(
          Uri.parse(
              'https://54.235.40.102.nip.io/admin/employees/employeeData?branchId=$branchId&status=active&employeeRole=delivery'),
        );

        if (response.statusCode == 200) {
          if (mounted) {
            setState(() {
              employees = json.decode(response.body)['data'];
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          throw Exception('Failed to load employees');
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        print('Error fetching employees: $e');
        // Show an error message to the user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to load employees. Please try again.')),
          );
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      throw Exception('Failed to retrieve branch ID');
    }
  }

  Future<void> assignOrderToEmployee(String orderId, String employeeId) async {
    final response = await http.post(
      Uri.parse('https://54.235.40.102.nip.io/user/delivery/assignOrderToDelivery'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'orderId': [int.parse(orderId)],
        'deliveryEmployeeId': employeeId,
      }),
    );

    if (response.statusCode == 200) {
      print('Order assigned successfully');
      // Optionally, you can fetch the delivery orders again to refresh the list
      fetchDeliveryOrders();
    } else {
      throw Exception('Failed to assign order');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems() {
    return employees.map<DropdownMenuItem<String>>((employee) {
      return DropdownMenuItem<String>(
        value: employee['fn_employee_id'].toString(),
        child: Text(
            '${employee['fn_employee_first_name']} ${employee['fn_employee_last_name']}'),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cashier Delivery Orders'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : deliveryOrders.isEmpty
              ? Center(
                  child: Text(
                    'No delivery orders available.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                )
              : ListView.builder(
                  itemCount: deliveryOrders.length,
                  itemBuilder: (context, index) {
                    final order = deliveryOrders[index];
                    final orderId = order['order_id'].toString();
                    return Card(
                      margin: EdgeInsets.all(10.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.motorcycle,
                            color: Colors.teal,
                            size: 50,
                          ),
                          title: Text(
                            'Order ID: ${order['order_id']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.teal,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        color: Colors.orange),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        '${order['customer_address']}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700]),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.phone, color: Colors.orange),
                                    SizedBox(width: 5),
                                    Text(
                                      '${order['customer_phone']}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                DropdownButton<String>(
                                  hint: Text('Select Delivery Person'),
                                  value: selectedEmployees[orderId],
                                  items: _buildDropdownMenuItems(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedEmployees[orderId] = value!;
                                    });
                                  },
                                  style: TextStyle(color: Colors.teal),
                                  dropdownColor: Colors.teal[50],
                                  iconEnabledColor: Colors.teal,
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: selectedEmployees[orderId] == null
                                      ? null
                                      : () {
                                          assignOrderToEmployee(orderId,
                                              selectedEmployees[orderId]!);
                                        },
                                  child: Text(
                                    'Assign Order',
                                    style: TextStyle(
                                        color: Colors
                                            .black), // Change text color to black
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
