import 'package:flutter/material.dart';

class DrawerItemModel {
  final String title;
  final IconData icon;
  final Widget destination;

  const DrawerItemModel({
    required this.title,
    required this.icon,
    required this.destination,
  });
}
