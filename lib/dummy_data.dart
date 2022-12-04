import 'package:tech387almir/models/patient.dart';

// ignore: constant_identifier_names
final List<Patient> DUMMY_DATA = [
  Patient(
    id: '1',
    name: 'Alen K.',
    disease: 'Common cold',
    image: 'assets/images/alen.png',
    date: DateTime.now(),
  ),
  Patient(
    id: '2',
    name: 'Andy A.',
    disease: 'Common cold',
    image: 'assets/images/andy.png',
    date: DateTime.now().add(const Duration(days: 1, hours: 3)),
  ),
  Patient(
    id: '3',
    name: 'Amy F.',
    disease: 'Right Arm Pain',
    image: 'assets/images/amy.png',
    date: DateTime.now().add(const Duration(minutes: 30)),
  ),
  Patient(
    id: '4',
    name: 'Bell B.',
    disease: 'Headache',
    image: 'assets/images/bell.png',
    date: DateTime.now().add(const Duration(days: 1, hours: 4)),
  ),
  Patient(
    id: '5',
    name: 'Kim.',
    disease: 'Headache',
    image: 'assets/images/kim.png',
    date: DateTime.now().add(const Duration(
      days: 1,
      hours: 5,
    )),
  ),
  Patient(
    id: '6',
    name: 'Nezir.',
    disease: 'Headache',
    image: 'assets/images/nezir.png',
    date: DateTime.now().add(const Duration(hours: 4, minutes: 10)),
  ),
  Patient(
    id: '7',
    name: 'Fiona.',
    disease: 'Covid 19',
    image: 'assets/images/fiona.png',
    date: DateTime.now().add(const Duration(hours: 1, minutes: 10)),
  ),
];
