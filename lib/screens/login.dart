import 'package:covid/helpers/user.dart';
import 'package:covid/screens/home.dart';
import 'package:covid/screens/registerPage.dart';

import 'package:covid/widgets/custom_button.dart';
import 'package:covid/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phno = TextEditingController();
  final TextEditingController _password = TextEditingController();
  List? result;
  String? name1;
  String? collage;
  bool flag = false;
  @override
  void initState() {
    super.initState();
    fetcheDatabaseList();
  }

  fetcheDatabaseList() async {
    result = await DataManager().getUserByNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Enter Your Registerd Phone Number & Password to Proceed",
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              Card(
                elevation: 7.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomTextField(
                          controller: _phno,
                          hintText: "+912856953214",
                          labelText: "Enter Your Phone Number",
                          icon: Icon(Icons.phone_android),
                          keyboardType: TextInputType.phone,
                          secure: false),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomTextField(
                        controller: _password,
                        secure: true,
                        hintText: "d",
                        labelText: "Enter Your Password",
                        icon: Icon(Icons.lock_outline),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.5),
                      child: Container(
                          width: 200.0,
                          child: CustomButton(
                            color: Colors.blue,
                            msg: "Log in",
                            onTap: () {
                              checkifExistsUser(
                                  context, _phno.text, _password.text);
                            },
                          )),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future<void> checkifExistsUser(
      BuildContext context, String phone, String password) async {
    for (var i = 0; i < result!.length; i++) {
      if (phone == result![i]['phone'] && password == result![i]['password']) {
        setState(() {
          name1 = result![i]['name'];
          collage = result![i]['collage'];
          flag = true;
        });
        break;
      } else {
        setState(() {
          flag = false;
        });
      }
    }
    if (flag) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool('data', true);
      preferences.setBool('signout', false);
      preferences.setBool('signout1', true);
      await Future.delayed(Duration(seconds: 3)).then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Home(true, name1!, phone, collage!)),
                (Route<dynamic> route) => false)
          });
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong , No User Found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
