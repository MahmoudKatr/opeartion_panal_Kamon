import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  late Future<Map<String, String?>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
  }

  Future<Map<String, String?>> _loadUserData() async {
    return {
      'employeeFirstName': _capitalize(await secureStorage.read(key: 'employee_first_name') ?? 'N/A'),
      'employeeLastName': _capitalize(await secureStorage.read(key: 'employee_last_name') ?? 'N/A'),
      'employeeRole': _capitalize(await secureStorage.read(key: 'employee_role') ?? 'N/A'),
      'employeeStatus': _capitalize(await secureStorage.read(key: 'employee_status') ?? 'N/A'),
      'employeePosition': _capitalize(await secureStorage.read(key: 'employee_position') ?? 'N/A'),
      'employeeBranchName': _capitalize(await secureStorage.read(key: 'employee_branch_name') ?? 'N/A'),
      'sectionName': _capitalize(await secureStorage.read(key: 'section_name') ?? 'N/A'),
      'picturePath': await secureStorage.read(key: 'picture_path') ?? 'N/A',
      'employeeBranchId': _handleIntValue(await secureStorage.read(key: 'employee_branch_id')),
      'branchSectionId': _handleIntValue(await secureStorage.read(key: 'branch_section_id')),
      'employeeId': _handleIntValue(await secureStorage.read(key: 'employee_id')),
    };
  }

  String _handleIntValue(String? value) {
    return value == null || value == '0' ? 'N/A' : value;
  }

  String _capitalize(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<Map<String, String?>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading profile data'));
            } else {
              final userData = snapshot.data ?? {};
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: userData['picturePath'] == null ||
                                    userData['picturePath'] == 'N/A' ||
                                    !Uri.tryParse(userData['picturePath']!)!.isAbsolute
                                ? NetworkImage('https://www.wonderplugin.com/wp-content/uploads/2013/12/Island_1024.jpg')
                                : NetworkImage(userData['picturePath']!),
                            backgroundColor: Colors.transparent,
                            onBackgroundImageError: (error, stackTrace) {
                              setState(() {
                                userData['picturePath'] = 'https://www.wonderplugin.com/wp-content/uploads/2013/12/Island_1024.jpg';
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildProfileDetail('Employee ID: ', userData['employeeId'], Icons.badge),
                        _buildProfileDetail('First Name: ', userData['employeeFirstName'], Icons.person),
                        _buildProfileDetail('Last Name: ', userData['employeeLastName'], Icons.person_outline),
                        _buildProfileDetail('Role: ', userData['employeeRole'], Icons.work),
                        _buildProfileDetail('Status: ', userData['employeeStatus'], Icons.check_circle),
                        _buildProfileDetail('Position: ', userData['employeePosition'], Icons.business_center),
                        _buildProfileDetail('Branch Name: ', userData['employeeBranchName'], Icons.location_city),
                        _buildProfileDetail('Branch ID: ', userData['employeeBranchId'], Icons.map),
                        _buildProfileDetail('Section ID: ', userData['branchSectionId'], Icons.account_tree),
                        _buildProfileDetail('Section Name: ', userData['sectionName'], Icons.account_balance),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple, size: 24),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
