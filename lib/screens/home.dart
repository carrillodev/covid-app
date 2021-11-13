import 'dart:developer';

import 'package:covid_app/models/register_model.dart';
import 'package:covid_app/screens/certificate.dart';
import 'package:covid_app/screens/locations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String url = 'https://coronavirus.gob.mx/contacto/';

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(25.5446328, -103.5174302),
    zoom: 12.4746,
  );

  Marker markerUjed = Marker(
    markerId: const MarkerId('ujed'),
    infoWindow: const InfoWindow(title: 'UJED'),
    position: const LatLng(25.5584436, -103.5108516),
    consumeTapEvents: true,
    onTap: () {},
  );

  Marker markerHospitalLerdo = Marker(
    markerId: const MarkerId('hospitalLerdo'),
    infoWindow: const InfoWindow(title: 'Hospital Gral. Lerdo'),
    position: const LatLng(25.5328062, -103.5305184),
    consumeTapEvents: true,
    onTap: () {},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Hola, ${Provider.of<RegisterModel>(context, listen: false).nombres}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Show Snackbar',
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  'Centros de vacunación',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey[800], fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: 200.0,
                        height: 180.0,
                        margin: const EdgeInsets.only(right: 15.0),
                        child: GoogleMap(
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: false,
                          myLocationEnabled: false,
                          rotateGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          tiltGesturesEnabled: false,
                          initialCameraPosition: _initialPosition,
                          markers: {markerUjed, markerHospitalLerdo},
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hay 2 centros de vacunación cerca.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: Colors.grey[800], fontSize: 16.0),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            'Selecciona el lugar que prefieras y agenda tu cita.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: Colors.grey[800], fontSize: 14.0),
                          ),
                          const SizedBox(height: 5.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LocationsPage(),
                                ),
                              );
                            },
                            child: const Text('Ver centros'),
                          ),
                        ],
                      ),
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
