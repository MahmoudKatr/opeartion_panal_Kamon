import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color baseColor = Color(0xFF4CAF50); // Define your base color here

final InputDecoration inputDecoration = InputDecoration(
  labelStyle: const TextStyle(fontSize: 18),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  filled: true,
  fillColor: Colors.grey[200],
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: baseColor),
    borderRadius: BorderRadius.circular(10),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: baseColor),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: baseColor),
    borderRadius: BorderRadius.circular(10),
  ),
);

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(12),
  backgroundColor: baseColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
).copyWith(
  textStyle: MaterialStateProperty.all<TextStyle>(
    GoogleFonts.lato(fontSize: 20, color: Colors.white),
  ),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
);

final ButtonStyle clearButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(12),
  backgroundColor: Colors.red,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
).copyWith(
  textStyle: MaterialStateProperty.all<TextStyle>(
    GoogleFonts.lato(fontSize: 20, color: Colors.white),
  ),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
);
