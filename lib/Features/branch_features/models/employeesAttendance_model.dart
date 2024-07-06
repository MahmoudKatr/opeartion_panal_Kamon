class EmployeesAttendanceModel {
  final String employee;
  final String shift_start_time;
  final String attendance_in;
  final String shift_end_time;
  final String attendance_out;

  EmployeesAttendanceModel(
      {required this.employee,
      required this.shift_start_time,
      required this.attendance_in,
      required this.shift_end_time,
      required this.attendance_out});

  factory EmployeesAttendanceModel.fromJson(Map<String, dynamic> jsonData) {
    return EmployeesAttendanceModel(
      employee: jsonData['employee'] ??
          'Default Employee', // Provide a default value or manage null
      shift_start_time:
          jsonData['shift_start_time'] ?? 'N/A', // Default value if null
      attendance_in:
          jsonData['attendance_in'] ?? 'N/A', // Default value if null
      shift_end_time:
          jsonData['shift_end_time'] ?? 'N/A', // Default value if null
      attendance_out:
          jsonData['attendance_out'] ?? 'N/A', // Default value if null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee'] = this.employee;
    data['shift_start_time'] = this.shift_start_time;
    data['attendance_in'] = this.attendance_in;
    data['shift_end_time'] = this.shift_end_time;
    data['attendance_out'] = this.attendance_out; // Corrected here

    return data;
  }
}
