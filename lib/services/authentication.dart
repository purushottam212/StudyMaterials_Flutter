import 'package:covid/helpers/user.dart';
import 'package:covid/screens/home.dart';
import 'package:covid/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Authentication {
  String? smsCode;
  String? verificationCode;
  String? number;
  String? uid;

  Future<void> submit(BuildContext context, String name, String password,
      String collage, String phone) async {
    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {
      FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((authResult) async {
        if (authResult.user != null) {
          var writeStatus = true;
          uid = authResult.user!.uid;

          DataManager().createUserData(
              name, password, collage, phone, authResult.user!.uid);

          //Navigator.of(context).pop();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      Home(writeStatus, name, phone, collage)),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pop();
        }
      });
    };

    final PhoneVerificationFailed phoneVerificationFailed = (exception) {
      Fluttertoast.showToast(
          // ignore: unnecessary_brace_in_string_interps
          msg:
              "Something went wrong kindly check ur Phone number ,your number is used for too many time or you forget to enter countrt code",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    };

    final PhoneCodeSent phoneCodeSent =
        (String? verId, [int? forceCodeResend]) {
      smsCodeDialog(context, name, password, collage, phone, uid!)
          .then((value) => print('sign in'));
      this.verificationCode = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verificationCode = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: verificationSuccess,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout,
        timeout: const Duration(seconds: 5));
  }

  smsCodeDialog(BuildContext context, String name, String password,
      String collage, String phone, String uid) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Enter Code",
              style: TextStyle(color: Colors.green[900]),
            ),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10),
            actions: [
              FlatButton(
                  onPressed: () {
                    signIn(context, name, password, collage, phone, uid);
                  },
                  child: Text(
                    "Verify",
                    style: TextStyle(color: Colors.green[900]),
                  ))
            ],
          );
        });
  }

  signIn(context, String name, String password, String collage, String phone,
      String uid) {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationCode!, smsCode: smsCode!);

    FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((user) {
      var writeData = true;
      DataManager().createUserData(name, password, collage, phone, uid);
      Navigator.of(context)
          .pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Home(writeData, name, phone, collage)),
              (Route<dynamic> route) => false)
          .catchError((e) => {
                Fluttertoast.showToast(
                    msg: "Something went wrong",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0)
              });
    });
  }

  Future signOut(context) async {
    FirebaseAuth.instance.signOut();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }
}
