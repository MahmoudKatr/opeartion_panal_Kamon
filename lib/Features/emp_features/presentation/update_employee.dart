import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'custom_dropdown.dart';

class UpdateEmployeeScreen extends StatefulWidget {
  const UpdateEmployeeScreen({Key? key}) : super(key: key);

  @override
  _UpdateEmployeeScreenState createState() => _UpdateEmployeeScreenState();
}

class _UpdateEmployeeScreenState extends State<UpdateEmployeeScreen> {
  String? email;
  String? password;
  String? confirmPassword;
  String? position = 'Branch Manager'; // Ensure initial value matches one of the items
  String? imageUrl;
  bool isLoading = false;
  String? employeeState = 'Resignation'; // Set an initial value

  @override
  Widget build(BuildContext context) {
    final employee = Get.arguments;

    if (employee != null) {
      print('ID: ${employee.id}');
      print('Title: ${employee.title}');
      print('Price: ${employee.price}');
      print('Description: ${employee.description}');
      print('Category: ${employee.category}');
      print('Image: ${employee.image}');
    } else {
      print('No employee data received.');
    }

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Update Employees'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Employee Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                },
              ),
              SizedBox(height: 20),
              buildDropdownMenu(
                  'Position',
                  position,
                  [
                    'Head Bar',
                    'Branch Manager',
                    'Head Barista'
                  ],
                  Icons.work,
                      (value) {
                    setState(() {
                      position = value;
                    });
                  }
              ),
              const SizedBox(height: 20),
              buildDropdownMenu(
                  'State',
                  employeeState,
                  [
                    'Resignation',
                    'Leave without pay'
                  ],
                  Icons.person,
                      (value) {
                    setState(() {
                      employeeState = value;
                    });
                  }
              ),



              SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                onChanged: (value) {
                  setState(() {
                    imageUrl = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  isLoading = true;
                  setState(() {});
                  print('Email: $email');
                  print('Password: $password');
                  print('Confirm Password: $confirmPassword');
                  print('Position: $position');
                  print('State: $employeeState');
                  print('Image URL: $imageUrl');
                  try {
                    // Call your function to update employee here
                  } on Exception catch (e) {
                    print(e.toString());
                  }
                  isLoading = false;
                  setState(() {});
                },
                child: Text('Update', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
