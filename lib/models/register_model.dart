import 'package:flutter/cupertino.dart';

class RegisterModel extends ChangeNotifier {
  late String curp;
  late String nombres;
  late String apellidoPaterno;
  late String apellidoMaterno;
  late String folioMiVacuna;
  late dynamic imageProfile;

  String get nombreCompleto => '$nombres $apellidoPaterno $apellidoMaterno';

  String get apellidos => '$apellidoPaterno $apellidoMaterno';
}
