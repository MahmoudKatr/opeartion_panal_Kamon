import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/add_register/style.dart';
import 'package:bloc_v2/screens/employe_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddEmployeeSchedule extends StatefulWidget {
  const AddEmployeeSchedule({Key? key}) : super(key: key);

  @override
  State<AddEmployeeSchedule> createState() => _AddEmployeeSchedule();
}

class _AddEmployeeSchedule extends State<AddEmployeeSchedule> {
  TextEditingController employeeIddController = TextEditingController();
  TextEditingController shiftStartTimeController = TextEditingController();
  TextEditingController shiftEndTimeController = TextEditingController();

  int _selectedIndex = 1;

  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Navigate to a screen, for example
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AllEmployeeScreen()));
    }
  }

  void clearForm() {
    shiftEndTimeController.clear();
    shiftStartTimeController.clear();
    setState(() {
      employeeIddController.clear();
    });
  }

  List<Map<String, dynamic>> activeEmployees = [];

  @override
  void initState() {
    super.initState();
    fetchActiveEmployees();
  }

  Future<void> fetchActiveEmployees() async {
    final url = Uri.parse(
        'https://54.235.40.102.nip.io/admin/employees/active-employees-list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          activeEmployees = jsonBody['data']
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

  Future<void> _selectDateTime(TextEditingController controller) async {
    // Pick the date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Pick the time after the date has been picked
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the date and time into a single DateTime object
        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format the picked date and time to show (yyyy-MM-dd HH:mm)
        String formattedDateTime = pickedDateTime.toString();

        setState(() {
          controller.text =
              formattedDateTime; // Update the respective controller
        });
      }
    }
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
                      // ignore: prefer_const_constructors
                      child: Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 50.0), // Padding above the toolbar
                          ),
                          Center(
                            child: Text(
                              'Add Employee Schedule',
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
                            items: activeEmployees.map((section) {
                              return DropdownMenuItem<int>(
                                value: section['employee_id'],
                                child: Text(section['employee_name']),
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
                            controller: shiftStartTimeController,
                            decoration: const InputDecoration(
                              labelText: 'Shift Start Time',
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
                              _selectDateTime(shiftStartTimeController);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the shift start time';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: shiftEndTimeController,
                            decoration: const InputDecoration(
                              labelText: 'Shift End Time',
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
                              _selectDateTime(shiftEndTimeController);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the shift end time';
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
                                label: const Text("Add Schedule Employee"),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final addRegisterEmp =
                                          await addEmployeeSchedule(
                                        employeeId: employeeIddController.text,
                                        shiftStartTime:
                                            shiftStartTimeController.text,
                                        shiftEndTime:
                                            shiftEndTimeController.text,
                                      );
                                      print('Adding Schedule: $addRegisterEmp');
                                      CherryToast.success(
                                        animationType: AnimationType.fromRight,
                                        toastPosition: Position.bottom,
                                        description: const Text(
                                          "Employee Schedule successfully added",
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
    path.lineTo(0, size.height - 50); // Adjusted height of the clip path
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

Future<String> addEmployeeSchedule({
  required String employeeId,
  required String shiftStartTime,
  required String shiftEndTime,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/employees/add-schedule';
  try {
    // Create a map and add only non-null values
    final Map<String, String> body = {
      'employee_id': employeeId,
      'shift_start_time': shiftStartTime,
      'shift_end_time': shiftEndTime,
    };

    final response = await http.post(
      Uri.parse(url),
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final addSchedule = response.body;
      print('Status: ${response.statusCode}');
      print('Response: $addSchedule');
      return addSchedule;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Failed to add schedule: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding schedule: $e');
  }
}
