import 'package:covid_app/models/register_model.dart';
import 'package:covid_app/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => RegisterModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;
  List<Slide> slides = [
    const Slide('images/slide2.png', 'Bienvenido(a) a COV-ID App',
        'La aplicación fiable y segura con la que podrás comprobar el estado de tu vacunación de forma rápida y sencilla'),
    const Slide('images/slide3.png', 'Toma tus precauciones',
        'Si vas a salir puedes ver en tiempo real la cantidad de personas vacunadas que hay en tu lugar de destino'),
    const Slide('images/slide4.png', 'Obtén un diagnóstico profesional',
        'Si crees que te has contagiado de COVID 19 te ayudaremos a detectar los síntomas sin salir de casa'),
    // const Slide('images/slide4.png', 'Recibe atención médica inmediata',
    //     'En caso de ser un caso confirmado, espera en casa y enviaremos asistencia médica especializada a tu domicilio')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              items: slides,
              carouselController: _controller,
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
            Dots(slides, _currentIndex),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterForm(),
                      ),
                    );
                  },
                  child: const Text('Siguiente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Dots extends StatelessWidget {
  final List<Slide> _slides;
  final int _current;
  const Dots(this._slides, this._current, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _slides.asMap().entries.map((e) {
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 15,
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

class Slide extends StatelessWidget {
  final String asset, title, description;

  const Slide(
    this.asset,
    this.title,
    this.description, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(asset),
            width: 150,
          ),
          const SizedBox(height: 20.0),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),
          Text(
            description,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
