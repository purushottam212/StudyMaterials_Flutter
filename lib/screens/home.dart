//import 'package:covid/screens/login.dart';
import 'dart:math';
import 'dart:ui';

import 'package:covid/helpers/collagelist.dart';
import 'package:covid/helpers/user.dart';
import 'package:covid/screens/additems.dart';
import 'package:covid/screens/descriptionscreen.dart';
import 'package:covid/services/authentication.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  bool writeStatus = false;
  bool signOutData = false;
  bool signOutData1 = true;
  String name;
  String phone;
  String collage;
  Home(
    this.writeStatus,
    this.name,
    this.phone,
    this.collage, {
    Key? key,
  }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List collagewisedata = List.empty(growable: true);
  List allData = List.empty(growable: true);
  List searchwiseresult = List.empty(growable: true);
  final TextEditingController search = TextEditingController();
  final TextEditingController collage = TextEditingController();
  @override
  void initState() {
    super.initState();

    loadData();

    fetchAllSellingData();
  }

  searchResult(String value) {
    var tempList =
        []; //to store value of collagewisedata list for temporary purpose or do not change the containt of actual list

    if (value == "") {
      setState(() {
        tempList = collagewisedata;
      });
    } else {
      for (var product in collagewisedata) {
        if (product['product title'].toString().contains(value)) {
          setState(() {
            //searchwiseresult = [];
            tempList.add(product);
          });
        } else
          Center(
            child: Text("No Product Availabel"),
          );
      }
    }
    setState(() {
      searchwiseresult = tempList;
    });
  }

  loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("data", widget.writeStatus);
  }

  writesignOutData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("signout", widget.signOutData);
  }

  writesignOutData1() async {
    SharedPreferences preferences = await SharedPreferences
        .getInstance(); //hey dusra fun ya sathi lihila ki ek user multiple
    //multiple times logout hou shakto ani aplyala fkt
    //logout zhlyavrch true lihaych ahe otherwise flase
    preferences.setBool("signout1", widget.signOutData1);
  }

  fetchAllSellingData() async {
    allData = await DataManager().getUserByNumberInSellInfo();

    for (var i = 0; i < allData.length; i++) {
      if (widget.collage == allData[i]['collage']) {
        collagewisedata.add(allData[i]);
      }
    }
    setState(() {
      searchwiseresult = collagewisedata;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.writeStatus);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("StudyMaterials"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Icon(
                  Icons.school_sharp,
                  color: Colors.black,
                ),
                onTap: showUpdateCollageDialog,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                child: Icon(Icons.settings, color: Colors.white60),
                onTap: () {
                  setState(() {
                    widget.signOutData = true;
                    widget.signOutData1 = false;
                  });
                  Authentication().signOut(context);
                  writesignOutData();
                  writesignOutData1();
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: 1,
          color: Colors.blue,
          backgroundColor: Colors.deepOrange,
          buttonBackgroundColor: Colors.white,
          height: 50.0,
          animationCurve: Curves.easeInOutSine,
          animationDuration: Duration(milliseconds: 300),
          items: <Widget>[
            Icon(
              Icons.add,
              size: 20.0,
            ),
            Icon(
              Icons.shopping_basket,
              size: 20.0,
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return AddItem(widget.name, widget.phone, widget.collage);
              }));
            } else {}
          },
        ),
        backgroundColor: Colors.grey[100],
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                //padding: const EdgeInsets.all(20),
                child: TextField(
                  autofocus: false,

                  onChanged: (value) {
                    searchResult(value);
                  },
                  decoration: InputDecoration(
                      labelText: "Search Your Product Here ",
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  //secure: false,
                  controller: search,
                  //icon: Icon(Icons.search),
                )),
          ),
          searchwiseresult.length != 0
              ? Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: searchwiseresult.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: GestureDetector(
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                elevation: 7.8,
                                //color: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(children: [
                                    Image.network(
                                        searchwiseresult[index]['image'],
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.28,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext? context,
                                            Widget? child,
                                            ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null)
                                        return child!;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 90.0),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              /*value: loadingProgress.expectedTotalBytes !=
                                                                 null
                                                             ? loadingProgress
                                                                     .cumulativeBytesLoaded /
                                                                 loadingProgress.expectedTotalBytes
                                                             : null,*/
                                              ),
                                        ),
                                      );
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        searchwiseresult[index]
                                            ['product title'],
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 15.8,
                                            fontStyle: FontStyle.italic,
                                            fontFamily: "serif",
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.grey,
                                      height: 0.2,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        "price: " +
                                            searchwiseresult[index]['price'] +
                                            "rs",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.8,
                                            fontFamily: 'serif',
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return DescriptionScreen(
                                      searchwiseresult[index]['image'],
                                      searchwiseresult[index]['product title'],
                                      searchwiseresult[index]
                                          ['product Description'],
                                      searchwiseresult[index]['price'],
                                      searchwiseresult[index]['name'],
                                      searchwiseresult[index]['phone']);
                                }));
                              }),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text("no product"),
                )
        ]));
  }

  /*displayAllSellingData()async{

  

  }*/
  showUpdateCollageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: AlertDialog(
              scrollable: true,
              title: Text(
                "Change Collage For Different Results..",
                style: TextStyle(color: Colors.deepPurple[900]),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: DropDownField(
                  icon: Icon(Icons.school),
                  controller: collage,
                  labelText: "Enter Collage Name",
                  labelStyle: TextStyle(fontSize: 11.3),
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
              contentPadding: EdgeInsets.all(10),
              actions: [
                FlatButton(
                    onPressed: () {
                      fetchAllSellingDataForUpdatedCollage(collage.text);
                      searchResult(collage.text);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.green[900]),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.green[900]),
                    ))
              ],
            ),
          );
        });
  }

  fetchAllSellingDataForUpdatedCollage(String updatedcollage) async {
    List fetchData = [];
    fetchData = await DataManager().getUserByNumberInSellInfo();

    if (updatedcollage.isEmpty) {
      setState(() {
        searchwiseresult = collagewisedata;
      });
    } else {
      setState(() {
        searchwiseresult = [];
        collagewisedata = [];
      });
    }

    for (var i = 0; i < fetchData.length; i++) {
      if (updatedcollage == fetchData[i]['collage']) {
        collagewisedata.add(fetchData[i]);
      }
    }
    setState(() {
      searchwiseresult = collagewisedata;
    });
  }
}
