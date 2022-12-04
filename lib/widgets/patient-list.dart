import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tech387almir/models/patient.dart';
import 'package:tech387almir/widgets/patient-item.dart';

class PatientList extends StatelessWidget {
  List<Patient> listPatients;
  PatientList(this.listPatients, {super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return listPatients.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No patients added yet!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return PatientItem(patient: listPatients[index]);
            },
            physics:
                const NeverScrollableScrollPhysics(), // izi fix za listview, izbjegavanje koristenja Column sa mapiranjem
            shrinkWrap: true,
            itemCount: listPatients.length,
          );
  }
}
