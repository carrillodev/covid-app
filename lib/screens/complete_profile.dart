import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/register_model.dart';
import 'package:covid_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  CollectionReference userProfiles =
      FirebaseFirestore.instance.collection('user_profiles');
  final ImagePicker _picker = ImagePicker();
  final String avatarBaseUrl = 'https://joeschmoe.io/api/v1/';
  Widget? selectedProfileImage;
  List<Widget> avatarList = [];
  String imgType = 'default';
  String? imgUrl;

  Icon defaultProfileImage(double size) {
    return Icon(
      Icons.person_outlined,
      color: Colors.grey[700],
      size: size,
    );
  }

  SvgPicture avatarProfileImage(String url) {
    return SvgPicture.network(
      url,
      width: 60.0,
      height: 60.0,
    );
  }

  Image fileProfileImage(String path) {
    return Image.file(
      File(path),
      width: 60.0,
      height: 60.0,
    );
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(
              'images/${Provider.of<RegisterModel>(context, listen: false).curp}')
          .putFile(file);
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }

  Future<void> saveUserProfile() {
    String curp = Provider.of<RegisterModel>(context, listen: false).curp;
    return userProfiles.doc(curp).set({
      'completed': true,
      'nombres': Provider.of<RegisterModel>(context, listen: false).nombres,
      'apellidos': Provider.of<RegisterModel>(context, listen: false).apellidos,
      'sexo': getGenderFromCurp(curp),
      'fecha_nacimiento': getBirthDateFromCurp(curp),
      'profile_image': {'type': imgType, 'url': imgUrl},
      'folio': Provider.of<RegisterModel>(context, listen: false).folioMiVacuna,
    });
  }

  String getGenderFromCurp(String curp) {
    String gender = curp.substring(10, 11);
    return gender == 'H' ? 'Masculino' : 'Femenino';
  }

  String getBirthDateFromCurp(String curp) {
    String year = curp.substring(4, 6);
    String month = curp.substring(6, 8);
    String day = curp.substring(8, 10);
    Intl.defaultLocale = 'es';
    DateTime birthDate = DateFormat('yy MM dd').parse('$year $month $day');
    return formatBirthDate(birthDate);
  }

  String formatBirthDate(DateTime birthDate) {
    DateFormat formatter = DateFormat('dd-MMMM-yyyy');
    return formatter.format(birthDate).replaceAll('-', ' de ');
  }

  @override
  void initState() {
    avatarList.add(defaultProfileImage(60.0));
    for (int i = 1; i <= 11; i++) {
      String url = avatarBaseUrl + i.toString();
      avatarList.add(avatarProfileImage(url));
    }
    selectedProfileImage = avatarList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16.0),
          ),
          onPressed: () async {
            imgType = 'default';
            imgUrl = null;
            context.read<RegisterModel>().imageProfile = null;
            await saveUserProfile()
                .then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    ))
                .catchError((error) => log(error));
          },
          child: const Text('Omitir'),
        ),
        leadingWidth: 70.0,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16.0),
            ),
            onPressed: () async {
              if (imgType == 'default') {
                context.read<RegisterModel>().imageProfile = null;
              } else {
                context.read<RegisterModel>().imageProfile =
                    selectedProfileImage;
                if (imgType == 'file') {
                  await uploadFile(imgUrl!);
                  imgUrl = null;
                }
              }
              await saveUserProfile()
                  .then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      ))
                  .catchError((error) => log(error));
            },
            child: const Text('Listo'),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
        child: Column(
          children: [
            Text(
              'Completa tu perfil',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey[800], fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Selecciona una imagen de perfil o toma una foto (esto es opcional y no afectará tu certificado).',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  color: Colors.grey[200]),
              child: selectedProfileImage,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Imágenes predeterminadas:',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  color: Colors.grey[100],
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  padding: const EdgeInsets.all(10.0),
                  children: List.generate(
                    avatarList.length,
                    (index) => OutlinedButton(
                      clipBehavior: Clip.antiAlias,
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          side: const BorderSide(style: BorderStyle.none),
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                      onPressed: () {
                        setState(() {
                          selectedProfileImage = avatarList[index];
                          imgType = index == 0 ? 'default' : 'svg';
                          if (index == 0) {
                            imgUrl = null;
                          } else {
                            imgUrl = avatarBaseUrl + index.toString();
                          }
                        });
                      },
                      child: OverflowBox(child: avatarList[index]),
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final XFile? photo =
                    await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  selectedProfileImage = fileProfileImage(photo!.path);
                  imgType = 'file';
                  imgUrl = photo.path;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.photo_camera,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Tomar una foto',
                    style: TextStyle(color: Colors.blueAccent),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);

                setState(() {
                  selectedProfileImage = fileProfileImage(image!.path);
                  imgType = 'file';
                  imgUrl = image.path;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.photo_library,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Imagen de la galería',
                    style: TextStyle(color: Colors.blueAccent),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
