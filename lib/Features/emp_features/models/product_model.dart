import 'package:flutter/material.dart';

class EmployeeModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  EmployeeModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  // Factory constructor to create an EmployeeModel from a JSON object
  factory EmployeeModel.fromJson(Map<String, dynamic> jsonData) {
    return EmployeeModel(
      id: jsonData['id'] ?? 0, // Example default value if 'id' is missing
      title: jsonData['title'] ?? '', // Example default value if 'title' is missing
      price: jsonData['price'] != null ? double.parse(jsonData['price'].toString()) : 0.0, // Parse 'price' to double
      image: jsonData['image'] ?? '', // Example default value if 'image' is missing
      description: jsonData['description'] ?? '', // Example default value if 'description' is missing
      category: jsonData['category'] ?? '', // Example default value if 'category' is missing
    );
  }


}

class RatingModel {
  double? rate;
  int? count;

  RatingModel({this.rate, this.count});

  RatingModel.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['count'] = this.count;
    return data;
  }
}
