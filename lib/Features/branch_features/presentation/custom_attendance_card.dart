import 'package:bloc_v2/Features/branch_features/models/employeesAttendance_model.dart';
import 'package:flutter/material.dart';

class CustomAattendanceCard extends StatelessWidget {
  final EmployeesAttendanceModel employeeA;

  const CustomAattendanceCard({
    required this.employeeA,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromARGB(255, 192, 215, 233),
                const Color.fromARGB(255, 255, 198, 194)
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  employeeA.employee as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
