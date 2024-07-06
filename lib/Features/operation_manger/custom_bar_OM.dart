import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomToolBarOM extends StatefulWidget {
  final List<String> titles;
  final List<IconData> icons;
  final List<VoidCallback> callbacks;

  CustomToolBarOM({
    Key? key,
    required this.titles,
    required this.icons,
    required this.callbacks,
  })  : assert(
            titles.length == icons.length && icons.length == callbacks.length,
            "Titles, icons, and callbacks must have the same length"),
        super(key: key);

  @override
  _CustomToolBarState createState() => _CustomToolBarState();
}

class _CustomToolBarState extends State<CustomToolBarOM> {
  int current = 0;

  final Color primaryColor = Colors.blue.shade600; // 60% of the design
  final Color secondaryColor = Colors.blue.shade300; // 30% of the design
  final Color accentColor = Colors.blue.shade900; // 10% of the design

  @override
  void initState() {
    super.initState();
    // Detailed debug statements
    print("Titles length: ${widget.titles.length}");
    print("Icons length: ${widget.icons.length}");
    print("Callbacks length: ${widget.callbacks.length}");
    print("Titles: ${widget.titles}");
    print("Icons: ${widget.icons}");
    print("Callbacks: ${widget.callbacks}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: primaryColor, // Primary color used for the toolbar background
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.titles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                current = index;
              });
              widget.callbacks[index]();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              width: _calculateWidth(index),
              decoration: BoxDecoration(
                color: current == index ? secondaryColor : primaryColor,
                borderRadius: BorderRadius.circular(20),
                border: current == index
                    ? Border.all(color: accentColor, width: 2.5)
                    : null,
                boxShadow: current == index
                    ? [
                        BoxShadow(
                          color: accentColor,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icons[index],
                      size: current == index ? 26 : 22,
                      color:
                          current == index ? accentColor : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.titles[index],
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        color: current == index
                            ? accentColor
                            : Colors.grey.shade400,
                        fontSize: current == index ? 16 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _calculateWidth(int index) {
    final text = widget.titles[index];
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 16.0), // Adjust font size if needed
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width + 30; // Adjust padding as needed
  }
}
