import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech387almir/DUMMY_DATA.dart';
import 'package:tech387almir/models/patient.dart';
import 'package:tech387almir/providers/auth_provider.dart';
import 'package:tech387almir/widgets/patient-list.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';
  HomeScreen({super.key});

  List<Patient> listPatients = DUMMY_DATA;

  //Uporedjujem trenutni datum tj. danasnji sa listom zakazanih datuma, ako je isti dan spremam preglede u novu listu i sortiram
  List<Patient>? get _todayPatients {
    List<Patient> temp = [];
    for (var i = 0; i < listPatients.length; i++) {
      if (listPatients[i].date.day == DateTime.now().day) {
        temp.add(listPatients[i]);
      }
    }
    temp.sort((a, b) => a.date.compareTo(b.date));
    return temp.toList();
  }

//Uporedjujem trenutni datum tj. danasnji sa listom zakazanih datuma, ako je dan trenutnog datuma manji od dana zakazanog termina, spremam ih u novu listu i sortiram
  List<Patient>? get _tomorrowPatients {
    List<Patient> temp = [];
    for (var i = 0; i < listPatients.length; i++) {
      if (listPatients[i].date.day > DateTime.now().day) {
        temp.add(listPatients[i]);
      }
    }
    temp.sort((a, b) => a.date.compareTo(b.date));
    return temp.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/productarena.png',
                width: 200,
                height: 100,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              //otvaranje novog alertdialoga za logout
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) {
                  final navigator = Navigator.of(
                      ctx); // mora ici iznad async poziva na eventu onPressed
                  return AlertDialog(
                    title: const Text('Log Out?'),
                    content: const Text(
                        'Are u sure you want to log out from the console?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          navigator.pop(false);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          navigator.pushReplacementNamed('/');
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .logout();
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              ),
              child: const Icon(Icons.logout_outlined),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  child: Image.asset('assets/images/profilna.png'),
                ),
                title: const Text(
                  'My Profile',
                ),
                subtitle: Text(
                  //primanje emaila za prikaz na home screenu
                  Provider.of<AuthProvider>(context).email!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Patient list for today',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PatientList(_todayPatients!),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Patient list for tomorrow',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PatientList(_tomorrowPatients!),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
