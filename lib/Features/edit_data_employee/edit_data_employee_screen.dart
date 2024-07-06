import 'dart:convert';
import 'package:bloc_v2/Features/edit_data_employee/edit_address_employee_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_change_postion_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_salary_only_employee_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_phone_employee_model.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_salary_position.dart';
import 'package:bloc_v2/app_layout_BM/screens/edit_transfer_employee.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'add_employee_phone.dart';

class EditEmployeeScreen extends StatefulWidget {
  final int employeeId;

  const EditEmployeeScreen({
    required this.employeeId,
    Key? key,
  }) : super(key: key);

  @override
  _EditEmployeeScreen createState() => _EditEmployeeScreen();
}

class _EditEmployeeScreen extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  void clearFormFields() {
    _formKey.currentState?.reset();
  }

  Future<List<String>> fetchPhones(int employeeId) async {
    final response = await http.get(Uri.parse(
        'https://54.235.40.102.nip.io/admin/employees/phones/$employeeId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final phones = data['data']['phones'] as List;
      return phones.map((phone) => phone['phone'].toString()).toList();
    } else {
      throw Exception('Failed to load phones');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPositions() async {
    final response = await http.get(
        Uri.parse('https://54.235.40.102.nip.io/admin/employees/positions-list'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final positions = data['data'] as List;
      return positions
          .map((position) => {
                'position_id': position['position_id'],
                'position': position['position']
              })
          .toList();
    } else {
      throw Exception('Failed to load positions');
    }
  }

  Future<List<Map<String, dynamic>>> fetchBranches() async {
    final response = await http
        .get(Uri.parse('https://54.235.40.102.nip.io/admin/branch/branches-list'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final branches = data['data'] as List;
      return branches
          .map((branch) => {
                'branch_id': branch['branch_id'],
                'branch_name': branch['branch_name']
              })
          .toList();
    } else {
      throw Exception('Failed to load branches');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Employee', style: GoogleFonts.lato()),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FutureBuilder<List<String>>(
                  future: fetchPhones(widget.employeeId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return FunctionInputTile(
                        functionName: 'Update Employee Phone',
                        attributeNames: const ['oldPhone', 'newPhone'],
                        oldPhoneDropdownItems: snapshot.data!,
                        onSubmit: (values) async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final addStorage_Model = await editPhoneEmployee(
                                employeeId: widget.employeeId,
                                oldPhone: values['oldPhone']!,
                                newPhone: values['newPhone']!,
                              );
                              print('Adding Storage: $addStorage_Model');
                              CherryToast.success(
                                animationType: AnimationType.fromRight,
                                toastPosition: Position.bottom,
                                description: const Text(
                                  "Changed Number successfully",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ).show(context);
                              clearFormFields();
                            } catch (e) {
                              print('Error Changed Number : $e');
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
                            print('Form is not valid');
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
                      );
                    }
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchPositions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return FunctionInputTile(
                        functionName: 'Change Position',
                        attributeNames: const [
                          'new_position',
                          'position_change_type'
                        ],
                        newPositionDropdownItems:
                            snapshot.data!, // Pass fetched positions
                        onSubmit: (values) async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final addStorage_Model =
                                  await editPositionEmployee(
                                employee_id: widget.employeeId,
                                new_position: values['new_position']!,
                                position_change_type:
                                    values['position_change_type']!,
                              );
                            } catch (e) {
                              print('Error Changed Salary : $e');
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
                            print('Form is not valid');
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
                      );
                    }
                  },
                ),
                FunctionInputTile(
                  functionName: 'Change Salary',
                  attributeNames: const ['newSalary', 'changeReason'],
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final Salary_Model = await editSalaryEmployee(
                          employeeId: widget.employeeId,
                          newSalary: values['newSalary']!,
                          changeReason: values['changeReason']!,
                        );
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Changed Salary successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error Changed Salary : $e');
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
                      print('Form is not valid');
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
                FunctionInputTile(
                  functionName: 'Update Employee Address',
                  attributeNames: const ['newAddress'],
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addStorage_Model = await editAddressEmployee(
                          employeeId: widget.employeeId,
                          newAddress: values['newAddress']!,
                        );
                        print('Adding Storage: $addStorage_Model');
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Change Address successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error adding storage: $e');
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
                      print('Form is not valid');
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
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchPositions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return FunctionInputTile(
                        functionName: 'Edit Employee Salary And Position',
                        attributeNames: const [
                          'newSalary',
                          'newPosition',
                          'positionChangeType',
                          'changeReason'
                        ],
                        newPositionDropdownItems: snapshot.data!,
                        onSubmit: (values) async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final SalaryAndPosition_Model =
                                  await editSalaryAndPositionEmployee(
                                employeeId: widget.employeeId,
                                newSalary: values['newSalary']!,
                                newPosition: values['newPosition']!,
                                positionChangeType:
                                    values['positionChangeType']!,
                                changeReason: values['changeReason']!,
                              );
                              clearFormFields();
                            } catch (e) {
                              print('Error Changed Salary and Position : $e');
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
                            print('Form is not valid');
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
                      );
                    }
                  },
                ),
                FunctionInputTile(
                  functionName: 'Add Employee Phone',
                  attributeNames: const ['Add Phone Number'],
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addPhoneNumber_Model =
                            await AddPhoneNumberEmployee(
                          employeeId: widget.employeeId,
                          employeePhone: values['Add Phone Number']!,
                        );
                        print('Adding Phone Number: $addPhoneNumber_Model');
                        if (addPhoneNumber_Model['status'] == 'success') {
                          CherryToast.success(
                            animationType: AnimationType.fromRight,
                            toastPosition: Position.bottom,
                            description: const Text(
                              "Phone number added successfully",
                              style: TextStyle(color: Colors.black),
                            ),
                          ).show(context);
                          clearFormFields();
                        } else {
                          CherryToast.error(
                            toastPosition: Position.bottom,
                            animationType: AnimationType.fromRight,
                            description: Text(
                              addPhoneNumber_Model['message'],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ).show(context);
                        }
                      } catch (e) {
                        print('Error adding phone number: $e');
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
                      print('Form is not valid');
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
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchBranches(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return FunctionInputTile(
                        functionName: 'Employee Transfer',
                        attributeNames: const ['branchId', 'transferReason'],
                        newPositionDropdownItems:
                            snapshot.data!, // Use fetched branches
                        onSubmit: (values) async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final editTransferEmployee_Model =
                                  await editTransferEmployee(
                                employeeId: widget.employeeId,
                                branchId: values['branchId']!,
                                transferReason: values['transferReason']!,
                              );
                              CherryToast.success(
                                animationType: AnimationType.fromRight,
                                toastPosition: Position.bottom,
                                description: const Text(
                                  "Transfer successful",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ).show(context);
                              clearFormFields();
                            } catch (e) {
                              print('Error in transfer: $e');
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
                            print('Form is not valid');
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
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FunctionInputTile extends StatefulWidget {
  final String functionName;
  final List<String> attributeNames;
  final void Function(Map<String, String> values) onSubmit;
  final List<String>? oldPhoneDropdownItems;
  final List<Map<String, dynamic>>? newPositionDropdownItems;

  FunctionInputTile({
    required this.functionName,
    required this.attributeNames,
    required this.onSubmit,
    this.oldPhoneDropdownItems,
    this.newPositionDropdownItems,
  });

  @override
  _FunctionInputTileState createState() => _FunctionInputTileState();
}

class _FunctionInputTileState extends State<FunctionInputTile> {
  late List<TextEditingController> _textControllers;
  bool _isExpanded = false;
  String? selectedOldPhone;
  String? selectedNewPosition;
  String? selectedBranch;
  final List<String> positionChangeTypes = ['Promote', 'Demote'];
  String? selectedPositionChangeType;

  @override
  void initState() {
    super.initState();
    _textControllers =
        widget.attributeNames.map((_) => TextEditingController()).toList();
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ClipPath(
        clipper: MyCustomClipper(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTile(
            title: Text(widget.functionName,
                style: GoogleFonts.lato(fontSize: 18, color: Colors.teal)),
            onExpansionChanged: (expanded) {
              _toggleExpand();
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ..._textControllers.asMap().entries.map((entry) {
                      int idx = entry.key;
                      TextEditingController controller = entry.value;
                      if (widget.attributeNames[idx] == 'oldPhone' &&
                          widget.oldPhoneDropdownItems != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedOldPhone,
                            items: widget.oldPhoneDropdownItems!.map((phone) {
                              return DropdownMenuItem(
                                value: phone,
                                child: Text(phone),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedOldPhone = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'Old Phone',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a phone';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.attributeNames[idx] == 'new_position' ||
                          widget.attributeNames[idx] == 'newPosition') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedNewPosition,
                            items: widget.newPositionDropdownItems!
                                .map((position) {
                              return DropdownMenuItem(
                                value: position['position_id']
                                    .toString(), // Store the position_id
                                child: Text(position['position']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedNewPosition = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'New Position',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a position';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.attributeNames[idx] ==
                          'Add Phone Number') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'Add Phone Number',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.attributeNames[idx] == 'branchId') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedBranch,
                            items:
                                widget.newPositionDropdownItems!.map((branch) {
                              return DropdownMenuItem(
                                value: branch['branch_id'].toString(),
                                child: Text(branch['branch_name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedBranch = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'Branch',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a branch';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.attributeNames[idx] ==
                              'position_change_type' ||
                          widget.attributeNames[idx] == 'positionChangeType') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedPositionChangeType,
                            items: positionChangeTypes.map((type) {
                              return DropdownMenuItem(
                                value:
                                    type.toLowerCase(), // Send lowercase value
                                child: Text(type), // Display capitalized
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPositionChangeType = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'Position Change Type',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a position change type';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.attributeNames[idx] == 'newSalary') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'New Salary',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a salary';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.attributeNames[idx] == 'newPhone') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'New Phone',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              return null;
                            },
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 1.5,
                              ),
                            ),
                            labelText: widget.attributeNames[idx],
                            labelStyle: GoogleFonts.lato(color: Colors.teal),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        textStyle: MaterialStateProperty.all(
                          GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (Form.of(context)?.validate() ?? false) {
                          final values = {
                            for (int i = 0;
                                i < widget.attributeNames.length;
                                i++)
                              widget.attributeNames[i]: widget
                                          .attributeNames[i] ==
                                      'oldPhone'
                                  ? selectedOldPhone!
                                  : widget.attributeNames[i] ==
                                              'new_position' ||
                                          widget.attributeNames[i] ==
                                              'newPosition'
                                      ? selectedNewPosition!
                                      : widget.attributeNames[i] == 'branchId'
                                          ? selectedBranch!
                                          : widget.attributeNames[i] ==
                                                      'position_change_type' ||
                                                  widget.attributeNames[i] ==
                                                      'positionChangeType'
                                              ? selectedPositionChangeType!
                                              : _textControllers[i].text
                          };
                          widget.onSubmit(values);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20); // Adjusted height of the clip path
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 20,
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
