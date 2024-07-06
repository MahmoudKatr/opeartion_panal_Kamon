class Employs {
  final int id;
  final String firstName;
  final String lastName;
  final String status;
  final String position;
  final String role;
  final String branchName;
  final int branchId;

  Employs({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.position,
    required this.role,
    required this.branchName,
    required this.branchId,
  });

  factory Employs.fromJson(Map<String, dynamic> json) {
    return Employs(
      id: json['employee_id'],
      firstName: json['employee_first_name'],
      lastName: json['employee_last_name'],
      status: json['employee_status'],
      position: json['employee_position'],
      role: json['employee_role'],
      branchName: json['employee_branch_name'],
      branchId: json['employee_branch_id'],
    );
  }
}
