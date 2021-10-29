import 'dart:developer';

import 'package:covid_app/screens/certificate.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String curp = 'CAAL991009HDGRLS09';
  final String url = 'https://coronavirus.gob.mx/contacto/';

  Future<void> getVaccinesData() async {
    CollectionReference appliedVaccines =
        firestore.collection('applied_vaccines');
    try {
      DocumentSnapshot vaccines = await appliedVaccines.doc(curp).get();
      Map<String, dynamic> data = vaccines.data() as Map<String, dynamic>;
      log('Successful');
    } on Exception catch (_) {
      log('Error!');
    }
  }

  void loadData() async {
    await getVaccinesData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  'Hola, Felipe Carrillo',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey[800]),
                ),
              ),
              Container(
                width: double.infinity,
                height: 160.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.blue,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[300]!,
                      Colors.blue,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Muestra tu certificado de vacunación',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white, fontSize: 18.0),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CertificateScreen()),
                              );
                            },
                            child: Text(
                              'Mostrar',
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image:
                              AssetImage('images/hand_holding_certificate.png'),
                          width: 120,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '¿Tienes síntomas de COVID 19?',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.grey[800], fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              Container(
                width: double.infinity,
                height: 160.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.cyan[400]!,
                      Colors.cyan[600]!,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage('images/medical_report.png'),
                          width: 100,
                        ),
                      ],
                    ),
                    const SizedBox(width: 20.0),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¿Crees que tú o alguien cercano a ti puede estar contagiado de COVID-19?',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white, fontSize: 16.0),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            onPressed: () async {
                              await canLaunch(url)
                                  ? await launch(url)
                                  : throw 'Could not launch $url';
                            },
                            child: Text(
                              'Obtener ayuda',
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  'Recomendaciones',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey[800], fontSize: 16.0),
                ),
              ),
              Container(
                height: 200.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 20.0),
                    SuggestionsCard(
                      'Utiliza mascarilla en público, especialmente en interiores.',
                      'images/facemask.png',
                      LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.purple[200]!,
                          Colors.purple[400]!,
                        ],
                      ),
                    ),
                    SuggestionsCard(
                      'Lávate las manos con frecuencia y haz uso de gel antibacterial.',
                      'images/sanitizer.png',
                      LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.pink[200]!,
                          Colors.pink[400]!,
                        ],
                      ),
                    ),
                    SuggestionsCard(
                      'Mantén una distancia de seguridad con otras personas.',
                      'images/social-distance.png',
                      LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.indigo[200]!,
                          Colors.indigo[400]!,
                        ],
                      ),
                    ),
                    SuggestionsCard(
                      'Limpia y desinfecta frecuentemente las superficies.',
                      'images/spray.png',
                      LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue[200]!,
                          Colors.blue[400]!,
                        ],
                      ),
                    ),
                    SuggestionsCard(
                      'Vacúnate cuando sea tu turno. Sigue las indicaciones.',
                      'images/injection.png',
                      LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.teal[200]!,
                          Colors.teal[400]!,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuggestionsCard extends StatelessWidget {
  final String info;
  final String imageUrl;
  final LinearGradient gradient;
  const SuggestionsCard(
    this.info,
    this.imageUrl,
    this.gradient, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 20.0,
      ),
      margin: const EdgeInsets.fromLTRB(0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Colors.blue,
        gradient: gradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(imageUrl),
            width: 60,
          ),
          const Spacer(),
          Text(
            info,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
