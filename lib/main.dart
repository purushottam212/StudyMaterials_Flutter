import 'package:covid/screens/home.dart';
import 'package:covid/screens/login.dart';
import 'package:covid/screens/registerPage.dart';
import 'package:covid/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(new MaterialApp(
    title: "StudyMaterials",
    home: StartScreen(),
  ));
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool? checkisAlredyLoggin;
  bool? checkLogOut;
  bool? checkwhichScreenToShow;
  String? name;
  String? phone;
  String? collage;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      checkisAlredyLoggin = preferences.getBool("data");
      checkLogOut = preferences.getBool("signout");
      checkwhichScreenToShow = preferences.getBool("signout1");
      name = preferences.getString("name");
      phone = preferences.getString("phone");
      collage = preferences.getString("collage");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (checkisAlredyLoggin == null ||
        checkisAlredyLoggin == false ||
        checkLogOut == null ||
        checkwhichScreenToShow == null) {
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: CustomButton(
                  color: Colors.deepOrange,
                  msg: "Sign up",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterPage();
                    }));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                    child: CustomButton(
                  color: Colors.blue,
                  msg: "Log in",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Login();
                    }));
                  },
                )),
              )
            ],
          ),
        ),
      );
    } else if (checkisAlredyLoggin == true && checkwhichScreenToShow == true) {
      return Home(checkisAlredyLoggin!, name!, phone!, collage!);
    } else if (checkLogOut == true && checkwhichScreenToShow == false) {
      return Login();
    } else {
      return Center(child: Text("Somenthing Went Wrong"));
    }
  }
}
