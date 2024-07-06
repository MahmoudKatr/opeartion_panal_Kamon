import 'package:bloc_v2/Features/emp_features/Data/add_position.dart';
import 'package:bloc_v2/add_register/style.dart';
import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';

class AddPositionScreen extends StatefulWidget {
  const AddPositionScreen({Key? key});

  @override
  State<AddPositionScreen> createState() => _AddPositionScreenState();
}

class _AddPositionScreenState extends State<AddPositionScreen> {
  TextEditingController positionNameController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController employeeRoleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    positionNameController.clear();
    jobDescriptionController.clear();
    setState(() {
      employeeRoleController.clear();
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
                      height: 150,
                      color: Colors.teal,
                      child: const Center(
                        child: Text(
                          'Add New Job Position',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                          TextFormField(
                            controller: positionNameController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            key: const ValueKey('position name'),
                            decoration: inputDecoration.copyWith(
                              labelText: 'Position Name',
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
                                return 'Please enter a position name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: employeeRoleController.text.isEmpty
                                ? null
                                : employeeRoleController.text,
                            onChanged: (newValue) {
                              setState(() {
                                employeeRoleController.text = newValue!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'manager',
                                child: Text('Manager'),
                              ),
                              DropdownMenuItem(
                                value: 'hr',
                                child: Text('HR'),
                              ),
                              DropdownMenuItem(
                                value: 'operation manager',
                                child: Text('Operation Manager'),
                              ),
                              DropdownMenuItem(
                                value: 'section manager',
                                child: Text('section manager'),
                              ),
                              DropdownMenuItem(
                                value: 'cashier',
                                child: Text('cashier'),
                              ),
                              DropdownMenuItem(
                                value: 'delivery',
                                child: Text('delivery'),
                              ),
                              DropdownMenuItem(
                                value: 'no role',
                                child: Text('no role'),
                              ),
                            ],
                            decoration: inputDecoration.copyWith(
                              labelText: 'Employee Role',
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
                                return 'Please select an Employee Role';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: jobDescriptionController,
                            key: const ValueKey('Job Description'),
                            minLines: 5,
                            maxLines: 6,
                            maxLength: 1000,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: inputDecoration.copyWith(
                              labelText: 'Job Description',
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
                                return 'Please enter a job description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                style: clearButtonStyle,
                                icon: const Icon(Icons.clear),
                                label: const Text("Clear"),
                                onPressed: () {
                                  clearForm();
                                },
                              ),
                              ElevatedButton.icon(
                                style: elevatedButtonStyle,
                                icon: const Icon(Icons.upload),
                                label: const Text("Add Position"),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final addPositionNameAndDescription =
                                          await addPosition(
                                        positionName:
                                            positionNameController.text,
                                        employeeRole:
                                            employeeRoleController.text,
                                        jop_description:
                                            jobDescriptionController.text,
                                      );
                                      print('object: ' +
                                          addPositionNameAndDescription);
                                      CherryToast.success(
                                        animationType: AnimationType.fromRight,
                                        toastPosition: Position.bottom,
                                        description: const Text(
                                          "Position added successfully",
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
