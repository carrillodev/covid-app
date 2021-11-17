import 'package:covid_app/models/register_model.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool value = true;

  @override
  Widget build(BuildContext context) {
    dynamic profileImage =
        Provider.of<RegisterModel>(context, listen: false).imageProfile;

    return SettingsList(
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
                  child: profileImage ??
                      Icon(
                        Icons.person_outlined,
                        color: Colors.grey[700],
                        size: 60.0,
                      ),
                ),
                Column(
                  children: [
                    Text(
                      'Luis Felipe',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.grey[800], fontSize: 20.0),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'Carrillo Alvarado',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
                const UserInfoColumn(
                  'Número de folio:',
                  'A18-75292167',
                ),
                const UserInfoColumn(
                  'CURP:',
                  'CAAL991009HDGRLS09',
                ),
                const UserInfoColumn(
                  'Fecha de nacimiento:',
                  '09 de Octubre de 1999',
                ),
                const UserInfoColumn(
                  'Sexo:',
                  'Masculino',
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
            SettingsTile(
              title: 'Modo oscuro',
              subtitle: 'Sistema',
              leading: const Icon(
                Icons.brightness_4,
              ),
              onPressed: (BuildContext context) {},
            ),
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
              onPressed: (BuildContext context) {},
            ),
            SettingsTile(
              title: 'Cambiar dirección de correo',
              leading: const Icon(
                Icons.mail,
              ),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile(
              title: 'Reportar un problema',
              leading: const Icon(
                Icons.report,
              ),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile(
              title: 'Ayuda',
              leading: const Icon(
                Icons.help_outlined,
              ),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile(
              title: 'Condiciones y políticas',
              leading: const Icon(
                Icons.gavel_outlined,
              ),
              onPressed: (BuildContext context) {},
            ),
          ],
        )
      ],
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
