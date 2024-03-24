import 'dart:convert';

class Box {
  final String barcode;
  final String geolocation;
  final String description;

  Box(
      {required this.barcode,
      required this.geolocation,
      required this.description});

  // Factory method to create a Box object from a JSON string
  factory Box.fromJson(Map<String, dynamic> json) {
    return Box(
        barcode: json['barcode'] ?? "",
        geolocation: json['geolocation'] ?? "",
        description: json['designation'] ?? "");
  }

  // Method to convert the Box object to a JSON representation
  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'geolocation': geolocation,
      'description': description,
    };
  }
}
