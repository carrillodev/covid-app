import 'package:covid_app/models/register_model.dart';
import 'package:covid_app/screens/verification.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showError = false;
  final _formKey = GlobalKey<FormBuilderState>();
  final phoneController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'MX');

  String? validateInput(value) {
    if (value == null || value.isEmpty) {
      return 'Debes ingresar tu folio de vacunación';
    }
    return null;
  }

  void setGlobalState(
    String curp,
    String nombres,
    String apellidoPaterno,
    String apellidoMaterno,
  ) {
    var registerModel = context.read<RegisterModel>();
    registerModel.curp = curp;
    registerModel.nombres = nombres;
    registerModel.apellidoPaterno = apellidoPaterno;
    registerModel.apellidoMaterno = apellidoMaterno;
  }

  Future<bool> checkExistence() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('vaccine_registers');
    String curp = _formKey.currentState!.fields['CURP']!.value;
    try {
      DocumentSnapshot user = await users.doc(curp).get();
      if (user.data() != null) {
        Map<String, dynamic> data = user.data() as Map<String, dynamic>;
        setGlobalState(
          curp,
          data['nombres'],
          data['apellido_paterno'],
          data['apellido_materno'],
        );
        return true;
      }
      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SafeArea(
          child: FormBuilder(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Introduce tus datos',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 30.0),
                  FormBuilderTextField(
                    name: 'CURP',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'CURP',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.max(context, 18),
                    ]),
                  ),
                  const SizedBox(height: 20.0),
                  FormBuilderTextField(
                    name: 'vaccineFolio',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Folio de vacunación',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.max(context, 12),
                    ]),
                  ),
                  const SizedBox(height: 20.0),
                  FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Correo electrónico',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.email(context),
                    ]),
                  ),
                  const SizedBox(height: 20.0),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {},
                    onInputValidated: (bool value) {},
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    initialValue: number,
                    formatInput: false,
                    countries: const ['MX'],
                    spaceBetweenSelectorAndTextField: 0,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Número celular',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.gavel,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          'Al registrarte estás de acuerdo con los términos y condiciones del servicio',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          'Tus datos guardados estarán seguros y no compreten tu privacidad, en tu certificado de vacunación mostramos únicamente la información necesaria.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Visibility(
                    child: Text(
                      'No te has registrado para tu vacuna aún.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.red),
                    ),
                    visible: showError,
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      bool isRegistered = await checkExistence();
                      if (_formKey.currentState!.validate() && isRegistered) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationPage(
                              phoneController.text,
                              'fakeID',
                            ),
                          ),
                        );
                        // await _auth.verifyPhoneNumber(
                        //   phoneNumber: phoneController.text,
                        //   verificationCompleted: (phoneAuthCredential) async {},
                        //   verificationFailed: (verificationFailed) async {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //         content: verificationFailed.message != null
                        //             ? Text(verificationFailed.message!)
                        //             : const Text('Verification Failed'),
                        //       ),
                        //     );
                        //   },
                        //   codeSent: (verificationId, resendingToken) async {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => VerificationPage(
                        //           phoneController.text,
                        //           verificationId,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   codeAutoRetrievalTimeout: (verificationId) async {},
                        // );
                      } else {
                        setState(() {
                          showError = true;
                        });
                      }
                    },
                    child: const Text('Validar registro'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
