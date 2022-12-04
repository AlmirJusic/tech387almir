import 'package:flutter/material.dart';

class Patient {
  final String id;
  final String name;
  final String disease;
  final String image;
  final DateTime date;

  Patient({
    required this.id,
    required this.name,
    required this.disease,
    required this.image,
    required this.date,
  });
}
