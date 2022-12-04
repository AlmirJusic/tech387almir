import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech387almir/models/patient.dart';

class PatientItem extends StatelessWidget {
  final Patient? patient;
  const PatientItem({required this.patient, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          child: Image.asset(patient!.image),
        ),
        title: Text(
          patient!.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          '${DateFormat.Hm().format(patient!.date)} - ${patient!.disease}',
        ),
      ),
    );
  }
}
