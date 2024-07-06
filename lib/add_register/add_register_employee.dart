import 'package:bloc_v2/Features/emp_features/presentation/all_emp_screen.dart';
import 'package:bloc_v2/add_register/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc_v2/add_register/add_register_model.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddRegisterEmp extends StatefulWidget {
  const AddRegisterEmp({Key? key}) : super(key: key);

  @override
  State<AddRegisterEmp> createState() => _AddRegisterEmpState();
}

class _AddRegisterEmpState extends State<AddRegisterEmp> {
  TextEditingController ssnNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController positionIdController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController branchIdController = TextEditingController();
  TextEditingController sectionIdController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateHiredController = TextEditingController();

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
    ssnNumberController.clear();
    firstNameController.clear();
    lastNameController.clear();
    genderController.clear();
    salaryController.clear();
    statusController.clear();
    birthDateController.clear();
    addressController.clear();
    dateHiredController.clear();
    setState(() {
      positionIdController.clear();
      branchIdController.clear();
      sectionIdController.clear();
    });
  }

  List<Map<String, dynamic>> branch = [];
  List<Map<String, dynamic>> positions = [];
  List<dynamic> sections = [];

  @override
  void initState() {
    super.initState();
    fetchBranch();
    fetchPositions();
  }

  Future<void> fetchBranch() async {
    final url =
        Uri.parse('https://54.235.40.102.nip.io/admin/branch/branches-list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          branch = jsonBody['data']
              .map<Map<String, dynamic>>((position) => {
                    'branch_id': position['branch_id'],
                    'branch_name': position['branch_name'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load branches');
      }
    } catch (e) {
      print('Error loading branches: $e');
    }
  }

  Future<void> fetchSections(int branchId) async {
    final url =
        Uri.parse('https://54.235.40.102.nip.io/admin/branch/sections/$branchId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data']['sections'];
        setState(() {
          sections = jsonData
              .map((section) => {
                    'id': section['id'],
                    'name': section['name'],
                    'manager': section['manager'],
                  })
              .toList();
        });
      } else {
        print('Failed to load sections');
      }
    } catch (e) {
      print('Error fetching sections: $e');
    }
  }

  Future<void> fetchPositions() async {
    final url =
        Uri.parse('https://54.235.40.102.nip.io/admin/employees/positions-list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          positions = (jsonBody['data'] as List).map((position) {
            return {
              'position_id': position['position_id'],
              'position': position['position'],
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load positions');
      }
    } catch (e) {
      print('Error loading positions: $e');
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = picked.toLocal().toString().split(' ')[0];

      setState(() {
        birthDateController.text = formattedDate;
      });
    }
  }

  Future<void> _HiredDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = picked.toLocal().toString().split(' ')[0];

      setState(() {
        dateHiredController.text = formattedDate;
      });
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
                  Stack(
                    children: [
                      ClipPath(
                        clipper: HeaderClipper(),
                        child: Container(
                          height: 150,
                          color: Colors.teal,
                          child: const Center(
                            child: Text(
                              'Add Employee Registration',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(14),
                            ],
                            controller: ssnNumberController,
                            keyboardType: TextInputType.number,
                            key: const ValueKey('SSN Number'),
                            decoration: inputDecoration.copyWith(
                              labelText: 'SSN Number *',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an SSN Number';
                              } else if (value.length != 14) {
                                return 'SSN Number must be 14 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: firstNameController,
                            key: const ValueKey('First Name'),
                            decoration: inputDecoration.copyWith(
                              labelText: 'First Name *',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: lastNameController,
                            key: const ValueKey('Last Name'),
                            decoration: inputDecoration.copyWith(
                              labelText: 'Last Name *',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: genderController.text.isEmpty
                                ? null
                                : genderController.text,
                            onChanged: (newValue) {
                              setState(() {
                                genderController.text = newValue!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'm',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'f',
                                child: Text('Female'),
                              ),
                            ],
                            decoration: inputDecoration.copyWith(
                              labelText: 'Gender *',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a gender';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: salaryController,
                            keyboardType: TextInputType.number,
                            key: const ValueKey('Salary'),
                            decoration: inputDecoration.copyWith(
                              labelText: 'Salary *',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a salary';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<int>(
                            value: positionIdController.text.isEmpty
                                ? null
                                : int.tryParse(positionIdController.text),
                            onChanged: (newValue) {
                              setState(() {
                                positionIdController.text =
                                    newValue?.toString() ?? '';
                              });
                            },
                            items: positions.map((position) {
                              return DropdownMenuItem<int>(
                                value: position['position_id'],
                                child: Text(position['position']),
                              );
                            }).toList(),
                            decoration: inputDecoration.copyWith(
                              labelText: 'Position *',
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
                                return 'Please select a position';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: statusController.text.isEmpty
                                ? null
                                : statusController.text,
                            onChanged: (newValue) {
                              setState(() {
                                statusController.text = newValue!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'pending',
                                child: Text('Pending'),
                              ),
                              DropdownMenuItem(
                                value: 'active',
                                child: Text('Active'),
                              ),
                              DropdownMenuItem(
                                value: 'inactive',
                                child: Text('Inactive'),
                              ),
                            ],
                            decoration: inputDecoration.copyWith(
                              labelText: 'Status *',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a status';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          DropdownButtonFormField<int>(
                            value: branchIdController.text.isEmpty
                                ? null
                                : int.tryParse(branchIdController.text),
                            onChanged: (newValue) {
                              setState(() {
                                branchIdController.text =
                                    newValue?.toString() ?? '';
                                if (newValue != null) {
                                  fetchSections(newValue);
                                }
                              });
                            },
                            items: branch.map((position) {
                              return DropdownMenuItem<int>(
                                value: position['branch_id'],
                                child: Text(position['branch_name']),
                              );
                            }).toList(),
                            decoration: inputDecoration.copyWith(
                              labelText: 'Branch Name (Optional)',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<int>(
                            value: sectionIdController.text.isEmpty
                                ? null
                                : int.tryParse(sectionIdController.text),
                            onChanged: (newValue) {
                              setState(() {
                                sectionIdController.text =
                                    newValue?.toString() ?? '';
                              });
                            },
                            items: sections.map((section) {
                              return DropdownMenuItem<int>(
                                value: section['id'],
                                child: Text(section['name']),
                              );
                            }).toList(),
                            decoration: inputDecoration.copyWith(
                              labelText: 'Section Name (Optional)',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: birthDateController,
                            decoration: const InputDecoration(
                              labelText: 'BirthDate *',
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectDate();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a birth date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: addressController,
                            key: const ValueKey('Address'),
                            decoration: inputDecoration.copyWith(
                              labelText: 'Address *',
                              labelStyle: const TextStyle(color: Colors.teal),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: dateHiredController,
                            decoration: const InputDecoration(
                              labelText: 'Date Hired (Optional)',
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
                              _HiredDate();
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
                                label: const Text("Add Register Employee"),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final addRegisterEmp =
                                          await addregisteremployee(
                                        ssnNumber: ssnNumberController.text,
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        gender: genderController.text,
                                        salary: salaryController.text,
                                        positionId: positionIdController.text,
                                        status: statusController.text,
                                        branchId:
                                            branchIdController.text.isNotEmpty
                                                ? branchIdController.text
                                                : null,
                                        sectionId:
                                            sectionIdController.text.isNotEmpty
                                                ? sectionIdController.text
                                                : null,
                                        birthDate: birthDateController.text,
                                        address: addressController.text,
                                        dateHired:
                                            dateHiredController.text.isNotEmpty
                                                ? dateHiredController.text
                                                : null,
                                      );
                                      print(
                                          'Employee registered: $addRegisterEmp');
                                      CherryToast.success(
                                        animationType: AnimationType.fromRight,
                                        toastPosition: Position.bottom,
                                        description: const Text(
                                          "Employee registered successfully",
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
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
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

Future<String> addregisteremployee({
  required String ssnNumber,
  required String firstName,
  required String lastName,
  required String gender,
  required String salary,
  required String positionId,
  required String status,
  String? branchId,
  String? sectionId,
  required String birthDate,
  required String address,
  String? dateHired,
}) async {
  const url = 'https://54.235.40.102.nip.io/admin/employees/employee';
  try {
    // Create a map and add only non-null values
    final Map<String, String> body = {
      'ssn': ssnNumber,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'salary': salary,
      'positionId': positionId,
      'status': status,
      'birthDate': birthDate,
      'address': address,
    };

    if (branchId != null) {
      body['branchId'] = branchId;
    }
    if (sectionId != null) {
      body['sectionId'] = sectionId;
    }
    if (dateHired != null) {
      body['dateHired'] = dateHired;
    }

    final response = await http.post(
      Uri.parse(url),
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      final addMenuItem = response.body;
      print('Status: ${response.statusCode}');
      print('Response: $addMenuItem');
      return addMenuItem;
    } else {
      // Failure
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Failed to add employee: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error adding employee: $e');
  }
}
