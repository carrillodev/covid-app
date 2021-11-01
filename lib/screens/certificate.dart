import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/register_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({Key? key}) : super(key: key);

  @override
  _CertificateScreenState createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String digitalSign = '';
  int _currentIndex = 0;
  List<Vaccine> vaccines = [];
  bool completeVaccination = false;

  Future<void> getVaccinesData() async {
    String curp = Provider.of<RegisterModel>(context, listen: false).curp;
    CollectionReference appliedVaccines =
        firestore.collection('applied_vaccines');
    try {
      DocumentSnapshot vaccinesData = await appliedVaccines.doc(curp).get();
      Map<String, dynamic> data = vaccinesData.data() as Map<String, dynamic>;
      digitalSign = data['sello_digital'];
      Map<String, dynamic> dosis = data['dosis'];
      if (dosis.isNotEmpty) {
        if (dosis.length == 2) completeVaccination = true;
        dosis.forEach((key, value) {
          Vaccine vaccine = Vaccine(
            int.parse(key),
            '2021-04-12',
            value['marca_vacuna'],
            value['lote_vacuna'],
            digitalSign,
          );
          setState(() {
            vaccines.add(vaccine);
          });
        });
      }
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
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var register = context.watch<RegisterModel>();
    return Scaffold(
      backgroundColor:
          completeVaccination ? Colors.green[400] : Colors.yellow[500],
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image(
                  image: AssetImage(completeVaccination
                      ? 'images/shield.png'
                      : 'images/clock.png'),
                  width: 100,
                ),
                Text(
                  completeVaccination ? 'Vacuna completa' : 'Vacuna incompleta',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey[800]),
                ),
                const SizedBox(height: 10.0),
                Column(
                  children: [
                    Text(
                      register.nombreCompleto,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey[600],
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      register.curp,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey[600],
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
                Expanded(
                  child: CarouselSlider(
                    items: vaccines,
                    options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: 450,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        }),
                  ),
                ),
                Dots(vaccines, _currentIndex),
                const SizedBox(height: 5.0),
                VaccinateColumn('Sello digital:', digitalSign),
                QrImage(
                  data: 'digitalSign',
                  version: QrVersions.auto,
                  size: 100.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150.0, 35.0)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Listo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Vaccine extends StatelessWidget {
  final int dosisNumber;
  final String applicationDate;
  final String vaccineManufacturer;
  final String vaccineLotNumber;
  final String digitalSign;

  const Vaccine(
    this.dosisNumber,
    this.applicationDate,
    this.vaccineManufacturer,
    this.vaccineLotNumber,
    this.digitalSign, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$dosisNumber° Dosis',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.grey[800], fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        VaccinateColumn(
          'Fecha de aplicación:',
          applicationDate,
          marginBottom: 8.0,
        ),
        VaccinateColumn(
          'Marca de la vacuna:',
          vaccineManufacturer,
          marginBottom: 8.0,
        ),
        VaccinateColumn(
          'Lote de la vacuna:',
          vaccineLotNumber,
        ),
      ],
    );
  }
}

class VaccinateColumn extends StatelessWidget {
  final String title;
  final String description;
  final double marginBottom;
  const VaccinateColumn(
    this.title,
    this.description, {
    Key? key,
    this.marginBottom = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.grey[800], fontSize: 18.0),
        ),
        const SizedBox(height: 5.0),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.grey[600],
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
        ),
        SizedBox(height: marginBottom),
      ],
    );
  }
}

class Dots extends StatelessWidget {
  final List<Vaccine> _slides;
  final int _current;
  const Dots(this._slides, this._current, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _slides.asMap().entries.map((e) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _current == e.key ? Colors.blue : Colors.grey[300],
          ),
        );
      }).toList(),
    );
  }
}
