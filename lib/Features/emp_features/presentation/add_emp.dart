import 'package:bloc_v2/Features/branch_features/Data/add_employe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddEmp extends StatefulWidget {
  const AddEmp({Key? key});

  @override
  State<AddEmp> createState() => _AddEmpState();
}

class _AddEmpState extends State<AddEmp> {
  TextEditingController idController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    idController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Employee'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: idController,
                      keyboardType: TextInputType.number,
                      key: const ValueKey('ID'),
                      decoration: const InputDecoration(
                        hintText: 'ID',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      key: const ValueKey('EMAIL'),
                      decoration: const InputDecoration(
                        hintText: 'EMAIL',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      key: const ValueKey('PASSWORD'),
                      decoration: const InputDecoration(
                        hintText: 'PASSWORD',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.clear),
                          label: const Text(
                            "Clear",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            clearForm();
                          },
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.upload),
                          label: Text(
                            isEditing ? "Edit Product" : "ADD Employee",
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final add_employee = await addEmploye(
                                  idNumber: idController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                print('Adding employee: $add_employee');
                                clearForm();
                              } catch (e) {
                                print('Error adding employee: $e');
                              }
                            } else {
                              print('Form is not valid');
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
