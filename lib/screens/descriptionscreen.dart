import 'package:covid/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DescriptionScreen extends StatelessWidget {
  var image;
  var title;
  var descrition;
  var price;
  var name;
  var phone;
  DescriptionScreen(this.image, this.title, this.descrition, this.price,
      this.name, this.phone);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(children: [
          Container(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(3),
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.33),
                      shape: BoxShape.rectangle),
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      this.image,
                      filterQuality: FilterQuality.low,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23.3)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    this.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.8,
                        color: Colors.cyan[800],
                        fontFamily: 'serif'),
                  ),
                ),
                Text(
                  "price:  " + this.price + "rs",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.2,
                      fontFamily: "serif",
                      fontStyle: FontStyle.italic,
                      color: Colors.deepPurpleAccent[900]),
                ),
                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Column(
                    children: [
                      Text(
                        "description:\n",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.2,
                            color: Colors.red),
                      ),
                      Text(
                        this.descrition,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.8,
                            color: Colors.indigo,
                            fontFamily: 'serif'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12.2),
                  child: Container(
                    color: Colors.grey,
                    height: 0.3,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Text(
                  "Seller Name: " + this.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.8,
                      color: Colors.pinkAccent,
                      fontFamily: 'serif'),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Seller Contact: " + this.phone,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.8,
                        color: Colors.green,
                        fontFamily: 'serif'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        msg: "Chat With Seller",
                        onTap: () {
                          Fluttertoast.showToast(
                              // ignore: unnecessary_brace_in_string_interps
                              msg: "These Feature will come soon",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        color: Colors.red,
                      ),
                      CustomButton(
                        msg: "Contact to Seller",
                        onTap: () {
                          _makePhoneCall('tel:$phone');
                        },
                        color: Colors.purple,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                      "To buy the product Communicate with seller with these two options",
                      style: TextStyle(
                        fontSize: 10.1,
                      )),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
