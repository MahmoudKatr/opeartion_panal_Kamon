class BranchModel {
  final int branchID;
  final String branchName;
  final String branchAddress;
  String? branchContactInformation;

  BranchModel(
      {required this.branchID,
      required this.branchName,
      required this.branchAddress,
      this.branchContactInformation});

  factory BranchModel.fromJson(Map<String, dynamic> jsonData) {
    return BranchModel(
      branchID: jsonData['branch_id'], // Corrected field names
      branchName: jsonData['branch_name'],
      branchAddress: jsonData['branch_address'],
      branchContactInformation:
          jsonData['branch_phone'], // Assuming phone is the contact info
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['branch_id'] = this.branchID;
    data['branch_name'] = this.branchName;
    data['branch_address'] = this.branchAddress;
    data['branch_contact_information'] = this.branchContactInformation;
    return data;
  }
}
