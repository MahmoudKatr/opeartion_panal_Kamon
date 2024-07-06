import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// PositionModel class
class PositionModel {
  final int id;
  final String name;
  final String? branch;
  final String position;

  PositionModel(
      {required this.id,
      required this.name,
      this.branch,
      required this.position});

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      id: json['id'],
      name: json['name'],
      branch: json['branch'],
      position: json['position'],
    );
  }
}

// Fetch positions function
Future<List<PositionModel>> fetchPositions() async {
  final response = await http.get(Uri.parse(
      'https://54.235.40.102.nip.io/admin/employees/manager-employees-list'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body)['data'];
    return jsonData.map((json) => PositionModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load positions');
  }
}

// Helper function to capitalize the first letter of each word
String capitalizeFirstLetterOfEachWord(String text) {
  if (text.isEmpty) return text;
  return text
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

// ManagersListScreen class
class ManagersListScreen extends StatefulWidget {
  @override
  _ManagersListScreenState createState() => _ManagersListScreenState();
}

class _ManagersListScreenState extends State<ManagersListScreen> {
  late Future<List<PositionModel>> futurePositions;

  @override
  void initState() {
    super.initState();
    futurePositions = fetchPositions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(), // Custom clipper if needed
            child: Container(
              color: Colors.teal.withOpacity(0.2),
              height: 200,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: FutureBuilder<List<PositionModel>>(
              future: futurePositions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No positions found'));
                } else {
                  final positions = snapshot.data!;
                  return ListView.builder(
                    itemCount: positions.length,
                    padding: EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) {
                      final position = positions[index];
                      return Card(
                        color: Colors.white,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Text(
                              position.name[0],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            capitalizeFirstLetterOfEachWord(position.name),
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                              color: Colors.teal,
                            ),
                          ),
                          subtitle: Text(
                            'Position: ${position.position}\nBranch: ${position.branch ?? "N/A"}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Example of a custom clipper if needed
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
