class ActiveEmployeesModel {
  final int employeeId;
  final String employeeName;
  final String employeeDateHired;
  final String employeeStatus;
  final String employeeBranch;
  final String employeeSection;
  final String employeePosition;
  final String? picturePath; // Added attribute
  final DateTime? inactiveDate; // Added attribute

  ActiveEmployeesModel({
    required this.employeeId,
    required this.employeeName,
    required this.employeeDateHired,
    required this.employeeStatus,
    required this.employeeBranch,
    required this.employeeSection,
    required this.employeePosition,
    this.picturePath, // Added attribute
    this.inactiveDate, // Added attribute
  });

  factory ActiveEmployeesModel.fromJson(Map<String, dynamic> jsonData) {
    return ActiveEmployeesModel(
      employeeId: jsonData['employee_id'] as int? ?? 0,
      employeeName: jsonData['employee_name'] as String? ?? 'N/A',
      employeeDateHired: jsonData['employee_date_hired'] as String? ?? 'N/A',
      employeeStatus: jsonData['employee_status'] as String? ?? 'N/A',
      employeeBranch: jsonData['employee_branch'] as String? ?? 'N/A',
      employeeSection: jsonData['empolyee_section'] as String? ?? 'N/A',
      employeePosition: jsonData['employee_position'] as String? ?? 'N/A',
      picturePath: jsonData['picture_path'] as String?, // Added attribute
    );
  }

  // Method to create a new instance with updated status and date
  ActiveEmployeesModel updateStatus(String newStatus) {
    return ActiveEmployeesModel(
      employeeId: employeeId,
      employeeName: employeeName,
      employeeDateHired: employeeDateHired,
      employeeStatus: newStatus,
      employeeBranch: employeeBranch,
      employeeSection: employeeSection,
      employeePosition: employeePosition,
      picturePath: picturePath,
      inactiveDate: newStatus == 'inactive' ? DateTime.now() : null,
    );
  }
}

class InActiveEmployeesModel {
  final int employeeId;
  final String employeeName;
  final String employeeDateHired;
  final String employeeStatus;
  final String employeeBranch;
  final String employeeSection;
  final String employeePosition;

  InActiveEmployeesModel({
    required this.employeeId,
    required this.employeeName,
    required this.employeeDateHired,
    required this.employeeStatus,
    required this.employeeBranch,
    required this.employeeSection,
    required this.employeePosition,
  });

  factory InActiveEmployeesModel.fromJson(Map<String, dynamic> jsonData) {
    return InActiveEmployeesModel(
      employeeId: jsonData['employee_id'] as int? ??
          0, // Cast and provide a default int value
      employeeName: jsonData['employee_name'] as String? ??
          'N/A', // Cast and provide a default String value
      employeeDateHired: jsonData['employee_date_hired'] as String? ?? 'N/A',
      employeeStatus: jsonData['employee_status'] as String? ?? 'N/A',
      employeeBranch: jsonData['employee_branch'] as String? ?? 'N/A',
      employeeSection: jsonData['empolyee_section'] as String? ??
          'N/A', // Corrected the key typo
      employeePosition: jsonData['employee_position'] as String? ?? 'N/A',
    );
  }
}
