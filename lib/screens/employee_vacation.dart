import 'dart:async';
import 'dart:convert';
import 'package:bloc_v2/add_register/style.dart';
import 'package:bloc_v2/screens/employee_vacation_model.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEmployeeVacation extends StatefulWidget {
  const AddEmployeeVacation({Key? key}) : super(key: key);

  @override
  State<AddEmployeeVacation> createState() => _AddEmployeeVacation();
}

class _AddEmployeeVacation extends State<AddEmployeeVacation> {
  TextEditingController employeeIddController = TextEditingController();
  TextEditingController vacationStartDateController = TextEditingController();
  TextEditingController vacationReasonController = TextEditingController();
  TextEditingController vacationEndController = TextEditingController();

  int _selectedIndex = 1;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> activeEmployees = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchActiveEmployees();
    startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchActiveEmployees();
    });
  }

  Future<void> fetchActiveEmployees() async {
    final url = Uri.parse(
        'https://54.235.40.102.nip.io/admin/employees/active-employees-list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          activeEmployees = (jsonBody['data'] as List)
              .map<Map<String, dynamic>>((employee) => {
                    'employee_id': employee['employee_id'],
                    'employee_name': employee['employee_name'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load active employees');
      }
    } catch (e) {
      print('Error loading active employees: $e');
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = picked.toLocal().toString().split(' ')[0];
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  void clearForm() {
    vacationStartDateController.clear();
    vacationReasonController.clear();
    vacationEndController.clear();
    setState(() {
      employeeIddController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  height: screenSize.height * 0.25,
                  color: Colors.teal.withOpacity(0.2),
                ),
              ),
              Column(
                children: [
                  ClipPath(
                    clipper: HeaderClipper(),
                    child: Container(
                      height:
                          150, // Adjusted height to fit the toolbar and text
                      color: Colors.teal,
                      child: const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 50.0), // Padding above the toolbar
                          ),
                          Center(
                            child: Text(
                              'Add Employee Vacation',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          DropdownButtonFormField<int>(
                            value: employeeIddController.text.isEmpty
                                ? null
                                : int.tryParse(employeeIddController.text),
                            onChanged: (newValue) {
                              setState(() {
                                employeeIddController.text =
                                    newValue?.toString() ?? '';
                              });
                            },
                            items: activeEmployees.map((employee) {
                              return DropdownMenuItem<int>(
                                value: employee['employee_id'],
                                child: Text(employee['employee_name']),
                              );
                            }).toList(),
                            decoration: inputDecoration.copyWith(
                              labelText: 'Employee Name',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an Employee Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: vacationStartDateController,
                            decoration: const InputDecoration(
                              labelText: 'Vacation Start Date',
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              labelStyle: TextStyle(color: Colors.teal),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectDate(vacationStartDateController);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: vacationEndController,
                            decoration: const InputDecoration(
                              labelText: 'Vacation End Date',
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              labelStyle: TextStyle(color: Colors.teal),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectDate(vacationEndController);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Vacation End Date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: vacationReasonController,
                            decoration: inputDecoration.copyWith(
                              labelText: 'Vacation Reason',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            maxLength: 150,
                            maxLines:
                                null, // Allows the text field to grow with the content
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a reason for the vacation';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                style: clearButtonStyle,
                                icon: const Icon(Icons.clear),
                                label: const Text("Clear"),
                                onPressed: clearForm,
                              ),
                              ElevatedButton.icon(
                                style: elevatedButtonStyle,
                                icon: const Icon(Icons.upload),
                                label: const Text("Add Vacation Employee"),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final addRegisterEmp =
                                          ModelEmployeeVacation(
                                        employeeId: employeeIddController.text,
                                        vacationStartDate:
                                            vacationStartDateController.text,
                                        vacationEndDate:
                                            vacationEndController.text,
                                        vacationReason:
                                            vacationReasonController.text,
                                      );
                                      print('Adding employee: $addRegisterEmp');
                                      CherryToast.success(
                                        animationType: AnimationType.fromRight,
                                        toastPosition: Position.bottom,
                                        description: const Text(
                                          "Employee Schedule successfully",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ).show(context);
                                      clearForm();
                                    } catch (e) {
                                      CherryToast.error(
                                        toastPosition: Position.bottom,
                                        animationType: AnimationType.fromRight,
                                        description: const Text(
                                          "Something went wrong!",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ).show(context);
                                    }
                                  } else {
                                    CherryToast.warning(
                                      toastPosition: Position.bottom,
                                      animationType: AnimationType.fromLeft,
                                      description: const Text(
                                        "Data is not valid or not complete",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ).show(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
