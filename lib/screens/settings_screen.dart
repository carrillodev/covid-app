import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/register_model.dart';
import 'package:covid_app/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  CollectionReference profiles =
      FirebaseFirestore.instance.collection('user_profiles');
  bool value = true;
  UserProfile? profile;
  Widget? imageProfile;

  Future<void> getUserData() async {
    String curp = Provider.of<RegisterModel>(context, listen: false).curp;
    DocumentSnapshot snapshot = await profiles.doc(curp).get();
    profile = UserProfile.fromJson(snapshot.data() as Map<String, dynamic>);
    imageProfile = await parseProfileImage(profile!.imgType!, profile!.imgUrl);
    setState(() {});
  }

  Future<String> downloadURL() async {
    String curp = Provider.of<RegisterModel>(context, listen: false).curp;
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('images/$curp')
        .getDownloadURL();
    return downloadURL;
  }

  Future<Widget> parseProfileImage(String imgType, String? imgUrl) async {
    if (imgType == 'svg') {
      return SvgPicture.network(imgUrl!);
    } else if (imgType == 'file') {
      String url = await downloadURL();
      return Image.network(
        url,
        width: 100.0,
        height: 100.0,
      );
    } else {
      return Icon(
        Icons.person_outlined,
        color: Colors.grey[700],
        size: 80.0,
      );
    }
  }

  void loadData() async {
    await getUserData();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return profile != null
        ? SettingsList(
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
            sections: [
              CustomSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              ),
              CustomSection(
                child: Container(
                  margin: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        margin: const EdgeInsets.only(bottom: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          color: Colors.grey[200],
                        ),
                        child: imageProfile,
                      ),
                      Column(
                        children: [
                          Text(
                            profile!.nombres,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: Colors.grey[800], fontSize: 20.0),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            profile!.apellidos,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                      UserInfoColumn(
                        'Número de folio:',
                        profile!.folio,
                      ),
                      UserInfoColumn(
                        'CURP:',
                        Provider.of<RegisterModel>(context, listen: false).curp,
                      ),
                      UserInfoColumn(
                        'Fecha de nacimiento:',
                        profile!.fechaNacimiento,
                      ),
                      UserInfoColumn(
                        'Sexo:',
                        profile!.sexo,
                      ),
                    ],
                  ),
                ),
              ),
              SettingsSection(
                title: 'Preferencias',
                tiles: [
                  SettingsTile.switchTile(
                    title: 'Notificaciones y sonidos',
                    leading: const Icon(Icons.notifications),
                    switchValue: value,
                    onToggle: (bool value) {
                      setState(() {
                        this.value = value;
                      });
                    },
                  ),
                  // SettingsTile(
                  //   title: 'Modo oscuro',
                  //   subtitle: 'Sistema',
                  //   leading: const Icon(
                  //     Icons.brightness_4,
                  //   ),
                  //   onPressed: (BuildContext context) {},
                  // ),
                  SettingsTile(
                    title: 'Privacidad',
                    leading: const Icon(
                      Icons.shield,
                    ),
                    onPressed: (BuildContext context) {},
                  ),
                ],
              ),
              SettingsSection(
                title: 'Cuenta y ayuda',
                tiles: [
                  SettingsTile(
                    title: 'Desvincular teléfono',
                    leading: const Icon(
                      Icons.no_cell,
                    ),
                    onPressed: (BuildContext context) async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                  SettingsTile(
                    title: 'Cambiar dirección de correo',
                    leading: const Icon(
                      Icons.mail,
                    ),
                    onPressed: (BuildContext context) {
                      showDialog(
                        context: context,
                        builder: (_) => const ChangeEmailDialog(),
                      );
                    },
                  ),
                  SettingsTile(
                    title: 'Reportar un problema',
                    leading: const Icon(
                      Icons.report,
                    ),
                    onPressed: (BuildContext context) {
                      showDialog(
                        context: context,
                        builder: (_) => const ReportDialog(),
                      );
                    },
                  ),
                  SettingsTile(
                    title: 'Ayuda',
                    leading: const Icon(
                      Icons.help_outlined,
                    ),
                    onPressed: (BuildContext context) {
                      showDialog(
                        context: context,
                        builder: (_) => const HelpDialog(),
                      );
                    },
                  ),
                  SettingsTile(
                    title: 'Condiciones y políticas de privacidad',
                    leading: const Icon(
                      Icons.gavel_outlined,
                    ),
                    onPressed: (BuildContext context) {
                      showDialog(
                        context: context,
                        builder: (_) => const TermsAndConditionsDialog(),
                      );
                    },
                  ),
                ],
              )
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class UserInfoColumn extends StatelessWidget {
  final String title;
  final String description;
  final double marginBottom;
  const UserInfoColumn(
    this.title,
    this.description, {
    Key? key,
    this.marginBottom = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.grey[800], fontSize: 16.0),
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

class TermsAndConditionsDialog extends StatelessWidget {
  const TermsAndConditionsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Condiciones de uso y políticas de privacidad'),
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Información relevante',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey[800], fontSize: 16.0)),
          const SizedBox(height: 10.0),
          Text(
            'La presente Política de Privacidad establece los términos en que COV-ID APP usa y protege la información que es proporcionada por sus usuarios al momento de utilizar su aplicación. Esta compañía está comprometida con la seguridad de los datos de sus usuarios. Cuando le pedimos llenar los campos de información personal con la cual usted pueda ser identificado, lo hacemos asegurando que sólo se empleará de acuerdo con los términos de este documento.',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 10.0),
          Text('Información que es recogida',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey[800], fontSize: 16.0)),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            'Nuestra aplicación podrá recoger información personal por ejemplo: Nombre,  información de contacto como  su dirección de correo electrónica e información demográfica. Así mismo cuando sea necesario podrá ser requerida información específica para procesar algún pedido o realizar una entrega o facturación.',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 10.0),
          Text('Enlaces a terceros',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey[800], fontSize: 16.0)),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            'Esta aplicación pudiera contener enlaces a otros sitios que pudieran ser de su interés. Una vez que usted de clic en estos enlaces y abandone nuestra página, ya no tenemos control sobre al sitio al que es redirigido y por lo tanto no somos responsables de los términos o privacidad ni de la protección de sus datos en esos otros sitios terceros. Dichos sitios están sujetos a sus propias políticas de privacidad por lo cual es recomendable que los consulte para confirmar que usted está de acuerdo con estas..',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

class HelpDialog extends StatelessWidget {
  const HelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ayuda'),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('COV-ID App',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey[800], fontSize: 16.0)),
          const SizedBox(height: 10.0),
          Text(
            'COV-ID App busca ayudar a que las personas puedan comprobar su actual estado de vacunación, obteniendo esta información desde sus celulares. Teniendo este recurso con un acceso fácil se pretende que en restaurantes, trabajos, cualquier establecimiento o incluso puntos fronterizos que soliciten este requerimiento, se pueda comprobar de manera veraz que se cumple con la vacunación, ya sea parcial o completamente.',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

class ChangeEmailDialog extends StatefulWidget {
  const ChangeEmailDialog({Key? key}) : super(key: key);

  @override
  _ChangeEmailDialogState createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  final _formKey = GlobalKey<FormBuilderState>();

  CollectionReference userProfiles =
      FirebaseFirestore.instance.collection('user_profiles');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar dirección de correo'),
      scrollable: true,
      content: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilderTextField(
              name: 'currentEmail',
              initialValue:
                  Provider.of<RegisterModel>(context, listen: false).email,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Correo actual',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.email(context),
              ]),
            ),
            const SizedBox(height: 20.0),
            FormBuilderTextField(
              name: 'newEmail',
              initialValue: '',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nuevo correo',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.email(context),
              ]),
            ),
            const SizedBox(height: 20.0),
            FormBuilderTextField(
              name: 'newEmailConfirm',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirma el nuevo correo',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.email(context),
              ]),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              String email = _formKey.currentState!.fields['newEmail']!.value;
              userProfiles
                  .doc(Provider.of<RegisterModel>(context, listen: false).curp)
                  .update({'email': email}).then((value) {
                Navigator.pop(context);
                _formKey.currentState!.reset();
              });
            }
          },
          child: const Text('Cambiar'),
        ),
      ],
    );
  }
}

class ReportDialog extends StatefulWidget {
  const ReportDialog({Key? key}) : super(key: key);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  CollectionReference problems =
      FirebaseFirestore.instance.collection('problems');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reportar un problema'),
      scrollable: true,
      content: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilderTextField(
              name: 'problem',
              autofocus: true,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Escribe aquí tu problema',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
              ]),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              String description =
                  _formKey.currentState!.fields['problem']!.value;
              problems.add({
                'author': {
                  'curp':
                      Provider.of<RegisterModel>(context, listen: false).curp,
                  'nombres': Provider.of<RegisterModel>(context, listen: false)
                      .nombres,
                  'apellidos':
                      Provider.of<RegisterModel>(context, listen: false)
                          .apellidos,
                  'email':
                      Provider.of<RegisterModel>(context, listen: false).email,
                },
                'date': DateTime.now(),
                'description': description,
              }).then((value) {
                Navigator.pop(context);
                _formKey.currentState!.reset();
              });
            }
          },
          child: const Text('Reportar'),
        ),
      ],
    );
  }
}
