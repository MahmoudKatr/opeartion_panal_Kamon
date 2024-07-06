import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  List<dynamic> deliveryOrders = [];
  Map<String, String> selectedStatus = {};
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchDeliveryOrders();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchDeliveryOrders();
    });
  }

  Future<void> fetchDeliveryOrders() async {
    String? branchId = await secureStorage.read(key: 'employee_branch_id');
    String? employeeId = await secureStorage.read(key: 'employee_id');
    if (branchId != null) {
      final response = await http.get(
        Uri.parse(
            'https://54.235.40.102.nip.io/user/delivery/deliveryOrders?employeeId=$employeeId&orderType=delivery&branchId=$branchId&inDeliveredOrders=true&deliveryStatus=assigned'),
      );

      if (response.statusCode == 200) {
        setState(() {
          deliveryOrders = (json.decode(response.body)['data'] as List)
              .where((order) => order['delivering_status'] == 'assigned')
              .toList();
          isLoading = false;
        });
      } else {
        print(
            'Failed to load delivery orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load delivery orders');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to retrieve branch ID');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final response = await http.patch(
      Uri.parse(
          'https://54.235.40.102.nip.io/user/delivery/changeDeliveryOrderStatus'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'orderId': orderId,
        'newStatus': status,
      }),
    );

    if (response.statusCode == 200) {
      print('Order status updated successfully');
      // Optionally, you can fetch the delivery orders again to refresh the list
      fetchDeliveryOrders();
    } else {
      throw Exception('Failed to update order status');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems() {
    return [
      DropdownMenuItem<String>(
        value: 'delivered',
        child: Text('Delivered'),
      ),
      DropdownMenuItem<String>(
        value: 'returned',
        child: Text('Returned'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery'),
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
                                  hint: Text('Select Status'),
                                  value: selectedStatus[orderId],
                                  items: _buildDropdownMenuItems(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStatus[orderId] = value!;
                                    });
                                  },
                                  style: TextStyle(color: Colors.teal),
                                  dropdownColor: Colors.teal[50],
                                  iconEnabledColor: Colors.teal,
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: selectedStatus[orderId] == null
                                      ? null
                                      : () {
                                          updateOrderStatus(orderId,
                                              selectedStatus[orderId]!);
                                        },
                                  child: Text(
                                    'Update Status',
                                    style: TextStyle(color: Colors.black),
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
