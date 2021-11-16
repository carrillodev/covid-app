import 'dart:io';

import 'package:covid_app/models/register_model.dart';
import 'package:covid_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final ImagePicker _picker = ImagePicker();
  String avatarBaseUrl = 'https://joeschmoe.io/api/v1/';
  List<Widget> avatarList = [];
  String imgType = 'icon';

  Widget defaultProfileImage(double size) {
    return Icon(
      Icons.person_outlined,
      color: Colors.grey[700],
      size: size,
    );
  }

  Widget avatarProfileImage(String url) {
    return SvgPicture.network(
      url,
      width: 60.0,
      height: 60.0,
    );
  }

  Widget fileProfileImage(String path) {
    return Image.file(
      File(path),
      width: 60.0,
      height: 60.0,
    );
  }

  Widget? selectedProfileImage;
  Color? imageProfileBackground;

  @override
  void initState() {
    avatarList.add(defaultProfileImage(60.0));
    for (int i = 1; i <= 11; i++) {
      String url = avatarBaseUrl + i.toString();
      avatarList.add(avatarProfileImage(url));
    }
    selectedProfileImage = avatarList[0];
    imageProfileBackground = Colors.grey[200];
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
          onPressed: () {
            var registerModel = context.read<RegisterModel>();
            selectedProfileImage = Icon(
              Icons.person_outlined,
              color: Colors.grey[700],
            );
            registerModel.imageProfile = selectedProfileImage;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: const Text('Omitir'),
        ),
        leadingWidth: 70.0,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16.0),
            ),
            onPressed: () {
              var registerModel = context.read<RegisterModel>();
              if (imgType == 'icon') {
                selectedProfileImage = Icon(
                  Icons.person_outlined,
                  color: Colors.grey[700],
                );
              }
              registerModel.imageProfile = selectedProfileImage;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
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
            const SizedBox(height: 30.0),
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
                color: imageProfileBackground,
              ),
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
                          backgroundColor:
                              index == 0 ? Colors.grey[300] : Colors.blue[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                      onPressed: () {
                        setState(() {
                          selectedProfileImage = avatarList[index];
                          if (index == 0) {
                            imageProfileBackground = Colors.grey[200];
                            imgType = 'icon';
                          }
                          imageProfileBackground = Colors.blue[200];
                          imgType = 'svg';
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
                  imageProfileBackground = Colors.grey[200];
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
                  imageProfileBackground = Colors.grey[200];
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
