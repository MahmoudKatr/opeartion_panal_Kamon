import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc_v2/Features/branch_features/models/branch_model.dart';
import 'show_details_branch.dart'; // Import the file where the details screen is

class CustomCard extends StatelessWidget {
  final BranchModel branch;

  CustomCard({
    required this.branch,
    Key? key,
  }) : super(key: key);

  final Color primaryColor = Colors.blue.shade600; // 60% of the design
  final Color secondaryColor = Colors.blue.shade300; // 30% of the design
  final Color accentColor = Colors.blue.shade900; // 10% of the design

  String capitalizeWords(String str) {
    if (str.isEmpty) return str;
    return str.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: secondaryColor,
          child: Text(
            branch.branchID.toString(),
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          capitalizeWords(branch.branchName),
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ShowDetailsBranch(branchId: branch.branchID),
              ),
            );
          },
        ),
      ),
    );
  }
}
