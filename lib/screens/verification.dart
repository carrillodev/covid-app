import 'package:covid_app/screens/certificate.dart';
import 'package:covid_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_state.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const VerificationPage(this.phoneNumber, this.verificationId, {Key? key})
      : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: const Color.fromRGBO(235, 236, 237, 1),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  String? verificationId;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CertificateScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  @override
  VerificationPage get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('images/verification.png'),
              width: 150,
            ),
            const SizedBox(height: 15.0),
            Text(
              'Hemos enviado un código de verificación a tu celular, esto puede tardar unos segundos.',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            PinPut(
              fieldsCount: 6,
              withCursor: true,
              fieldsAlignment: MainAxisAlignment.spaceEvenly,
              eachFieldHeight: 45.0,
              eachFieldWidth: 45.0,
              textStyle: const TextStyle(fontSize: 16.0, color: Colors.black),
              onSubmit: (String value) async {
                PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: value,
                );
                signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: _pinPutDecoration,
              selectedFieldDecoration: _pinPutDecoration.copyWith(
                color: Colors.white,
                border: Border.all(
                  width: 2,
                  color: const Color.fromRGBO(0, 119, 255, 1),
                ),
              ),
              followingFieldDecoration: _pinPutDecoration,
            ),
            const SizedBox(height: 40.0),
            Text(
              '¿Todavía no recibes el código?',
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text(
                'Intentar de nuevo',
                style: TextStyle(color: Colors.blueAccent),
              ),
            )
          ],
        ),
      ),
    );
  }
}
