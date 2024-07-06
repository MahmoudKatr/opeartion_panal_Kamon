import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String text;
  final String photoUrl;
  //final Widget destination;
  const CustomCard({
    Key? key,
    required this.text,
    required this.photoUrl,
   // required this.destination
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            photoUrl,
            width: double.infinity,
            height: 100,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            color: Colors.black.withOpacity(0.5), // Adjust transparency here
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // Text color
              ),
              textAlign: TextAlign.center, // Center align text
            ),
          ),
        ],
      ),
    );
  }
}
