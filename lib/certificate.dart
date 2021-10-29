import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uuid/uuid.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({Key? key}) : super(key: key);

  @override
  _CertificateScreenState createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  String digitalSign = const Uuid().v4();
  late List<Vaccine> vaccines = [];
  int _currentIndex = 0;

  @override
  void initState() {
    vaccines = [
      Vaccine(1, '2021-04-12', 'Pfizer', 'EW4109', digitalSign),
      Vaccine(2, '2021-05-12', 'Pfizer', 'EW4109', digitalSign),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[400],
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
                const Image(
                  image: AssetImage('images/shield.png'),
                  width: 100,
                ),
                Text(
                  'Vacuna completa',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey[800]),
                ),
                const SizedBox(height: 10.0),
                Column(
                  children: [
                    Text(
                      'Luis Felipe Carrillo Alvarado',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey[600],
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'CAAL991009HDGRLS09',
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
