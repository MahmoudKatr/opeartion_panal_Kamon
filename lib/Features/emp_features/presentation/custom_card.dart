import 'package:bloc_v2/Features/emp_features/presentation/ShowAllDataAboutEmployee_scren.dart';
import 'package:bloc_v2/Features/emp_features/presentation/edit_change_status_model.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:bloc_v2/Features/edit_data_employee/edit_data_employee_screen.dart';
import 'package:bloc_v2/Features/emp_features/models/active_emp_model.dart';

class CustomCard extends StatefulWidget {
  final ActiveEmployeesModel activeEmployee;
  final Function startPolling;

  const CustomCard({
    required this.activeEmployee,
    required this.startPolling,
    Key? key,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late ActiveEmployeesModel activeEmployee;

  @override
  void initState() {
    super.initState();
    activeEmployee = widget.activeEmployee;
  }

  String capitalize(String s) => s.isNotEmpty
      ? s
          .split(' ')
          .map((word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
          .join(' ')
      : '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final capitalizedEmployeeName = capitalize(activeEmployee.employeeName);

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: activeEmployee.employeeStatus == 'active'
              ? Colors.green
              : Colors.red,
          width: 2.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: activeEmployee.picturePath != null &&
                        activeEmployee.picturePath!.isNotEmpty
                    ? NetworkImage(activeEmployee.picturePath!)
                    : null,
                child: activeEmployee.picturePath == null ||
                        activeEmployee.picturePath!.isEmpty
                    ? Icon(Icons.person, size: 25)
                    : null,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizedEmployeeName,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      capitalize(activeEmployee.employeePosition),
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          activeEmployee.employeeStatus == 'active'
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: activeEmployee.employeeStatus == 'active'
                              ? Colors.green
                              : Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          activeEmployee.employeeStatus == 'active'
                              ? 'Active'
                              : 'Inactive',
                          style: TextStyle(
                            fontSize: 12,
                            color: activeEmployee.employeeStatus == 'active'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        if (activeEmployee.inactiveDate != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Inactive since: ${DateFormat('yyyy-MM-dd').format(activeEmployee.inactiveDate!)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowAllDataAboutEmployee(
                        employee: activeEmployee,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.remove_red_eye, color: theme.iconTheme.color),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEmployeeScreen(
                        employeeId: activeEmployee.employeeId,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: theme.iconTheme.color),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              IconButton(
                onPressed: () {
                  _showDeleteDialog(
                      context, activeEmployee.employeeId.toString());
                },
                icon: Icon(
                  activeEmployee.employeeStatus == 'active'
                      ? Icons.cancel
                      : Icons.check_circle,
                  color: activeEmployee.employeeStatus == 'active'
                      ? Colors.red
                      : Colors.green,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String employeeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Select Action',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
          ),
          content: Text(
            'What do you want to do with this employee?',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                try {
                  final newStatus = activeEmployee.employeeStatus == 'active'
                      ? 'inactive'
                      : 'active';
                  final addStorage_Model = await editChangeStatusModel(
                    employeeId: employeeId,
                    employeeStatus: newStatus,
                  );
                  print('Adding Storage: $addStorage_Model');
                  setState(() {
                    activeEmployee = activeEmployee.updateStatus(newStatus);
                  });
                  CherryToast.success(
                    animationType: AnimationType.fromRight,
                    toastPosition: Position.bottom,
                    description: const Text(
                      "Edit Status successfully",
                      style: TextStyle(color: Colors.black),
                    ),
                  ).show(context);
                  Navigator.of(context).pop();
                  widget.startPolling(); // Call startPolling here
                } catch (e) {
                  print('Error add menu item: $e');
                  CherryToast.error(
                    toastPosition: Position.bottom,
                    animationType: AnimationType.fromRight,
                    description: const Text(
                      "Something went wrong!",
                      style: TextStyle(color: Colors.black),
                    ),
                  ).show(context);
                }
              },
              child: Text(
                activeEmployee.employeeStatus == 'active'
                    ? 'Set Inactive'
                    : 'Set Active',
                style: TextStyle(color: Colors.teal),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }
}
