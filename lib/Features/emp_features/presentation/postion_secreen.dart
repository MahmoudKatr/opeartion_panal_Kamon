import 'package:bloc_v2/Features/emp_features/Data/get_all_positions.dart';
import 'package:bloc_v2/Features/emp_features/models/positon_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PositionListScreen extends StatefulWidget {
  @override
  _PositionListScreenState createState() => _PositionListScreenState();
}

class _PositionListScreenState extends State<PositionListScreen> {
  late Future<List<PositionModel>> futurePositions;

  @override
  void initState() {
    super.initState();
    // Ensure that the future is initialized
    futurePositions = fetchPositions();
  }

  final Map<String, IconData> positionIcons = {
    'hr': Icons.people,
    'operation manager': Icons.settings,
    'logistics coordinator': Icons.local_shipping,
    'head bar': Icons.local_bar,
    'barista': Icons.local_cafe,
    'head waiter': Icons.restaurant,
    'dish washer': Icons.kitchen,
    'delivery driver': Icons.delivery_dining,
    'chief': Icons.restaurant_menu,
    'cashier': Icons.point_of_sale,
    'kitchen manager': Icons.kitchen,
    'assistant manager': Icons.assistant,
    'branch manager': Icons.store,
    'call center': Icons.call,
    'general manager 3': Icons.business_center,
    'general manager 2': Icons.business_center,
  };

  IconData _getIconForPosition(String position) {
    return positionIcons[position.toLowerCase()] ?? Icons.work;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              color: Colors.teal.withOpacity(0.2),
              height: 200,
            ),
          ),
          FutureBuilder<List<PositionModel>>(
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
                  itemBuilder: (context, index) {
                    final position = positions[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(
                            _getIconForPosition(position.jobName),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          position.jobName,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        subtitle: Text('ID: ${position.positionId}'),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
