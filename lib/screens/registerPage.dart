import 'dart:ui';

import 'package:covid/helpers/collagelist.dart';
import 'package:covid/helpers/user.dart';

import 'package:covid/services/authentication.dart';
import 'package:covid/widgets/custom_button.dart';
import 'package:covid/widgets/custom_text_field.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController phoneNo = new TextEditingController();
  final TextEditingController name = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  final TextEditingController collage = new TextEditingController();
  List? result;
  bool? check;
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(children: [
          Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Container(
                      // margin: const EdgeInsets.only(top: 25.5),
                      child: Image.network(
                        "https://www.study-material.info/wp-content/uploads/2015/11/Study-Material-Logo-Retina-final.png",
                        height: 110.0,
                        width: 150.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text("Welcome to Study Materials!",
                      style: TextStyle(
                          fontFamily: "Cursive",
                          fontSize: MediaQuery.of(context).size.width >= 300
                              ? 30.0
                              : 22.0,
                          fontWeight: FontWeight.bold,

                          //fontStyle: FontStyle.italic,
                          color: Colors.deepPurple)),
                  Text("Register Yourself to Procced!!",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.deepOrange)),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      elevation: 8.0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 11.0),
                            child: CustomTextField(
                              icon: Icon(Icons.phone),
                              secure: false,
                              hintText: "Enter Your Phone Number",
                              labelText: "+914475823654",
                              controller: phoneNo,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: CustomTextField(
                              icon: Icon(Icons.person),
                              secure: false,
                              hintText: " Eg:Amit",
                              labelText: "Enter Your Name",
                              controller: name,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: CustomTextField(
                              icon: Icon(Icons.lock),
                              hintText: "Eg:Patil",
                              labelText: "Enter Password",
                              controller: password,
                              keyboardType: TextInputType.text,
                              secure: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              color: Colors.white,
                              borderOnForeground: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          offset: Offset(2, 1),
                                          blurRadius: 2)
                                    ]),
                                child: DropDownField(
                                  icon: Icon(Icons.school),
                                  controller: collage,
                                  labelText: "Enter Collage Name",
                                  //labelStyle: TextStyle(fontSize: 12.3),
                                  hintText: "from drop-down menu only",
                                  hintStyle: TextStyle(fontSize: 8.8),
                                  enabled: true,
                                  items: CollageList().collageList,
                                  onValueChanged: (value) {
                                    setState(() {
                                      collage.text = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          /*Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: CustomTextField(
                                icon: Icon(Icons.school),
                                secure: false,
                                hintText: "  Eg:COEP",
                                labelText: "Enter Your Collage Name",
                                controller: collage,
                                keyboardType: TextInputType.text,
                              ),
                            ),*/
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,

                              child: CustomButton(
                                color: Colors.redAccent,
                                msg: "Register",
                                onTap: () {
                                  checkuserexiststillregister(phoneNo.text);
                                  setState(() {
                                    if (phoneNo.text != "" &&
                                        name.text != "" &&
                                        collage.text != "" &&
                                        password.text != "") {
                                      // check == false) {
                                      Authentication().submit(
                                          context,
                                          name.text,
                                          password.text,
                                          collage.text,
                                          phoneNo.text);
                                      phoneNo.clear();
                                      collage.clear();
                                      name.clear();
                                      password.clear();
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Kindly Check All Fields..All fields Are Required..Or You May Entered Phone Number That IS Alreday Exists",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.grey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ]),
      ),
    );
  }

  checkuserexiststillregister(String phone) {
    for (var i = 0; i < result!.length; i++) {
      if (phone == result![i]['phone']) {
        setState(() {
          check = true;
        });
        break;
      } else {
        check = false;
      }
    }
  }
}
