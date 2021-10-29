import 'dart:io';
import 'package:covid/models/user.dart';
import 'package:covid/screens/home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:uuid/uuid.dart';
import 'package:covid/helpers/user.dart';
import 'package:covid/screens/editscreen.dart';
import 'package:covid/widgets/custom_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AddItem extends StatefulWidget {
  String name;
  String phone;
  String collage;

  AddItem(this.name, this.phone, this.collage);

  @override
  _AddItemState createState() => _AddItemState();

  void updateData(int index, displayData) {}
}

class _AddItemState extends State<AddItem> {
  final TextEditingController productTitle = new TextEditingController();
  final TextEditingController productDes = new TextEditingController();
  final TextEditingController price = new TextEditingController();
  File? image;
  var userId;
  var uuid = Uuid();
  String? imageLink;
  bool updateOrNot = false;
  SellModel? sellmodelobj;
  var producttitle;
  Future getImage() async {
    PickedFile? img = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      image = File(img.path);
    });
  }

  uploadImage() async {
    FirebaseStorage fs = FirebaseStorage.instance;
    var put = fs.ref().child(widget.name.toString() + uuid.v1().toString());

    put.putFile(image!).onComplete.then((value) async {
      String link = await value.ref.getDownloadURL();

      setState(() {
        imageLink = link;
      });
      DataManager().sellingData(
          uuid.v1().toString(),
          widget.name,
          widget.collage,
          widget.phone,
          imageLink!,
          productTitle.text,
          productDes.text,
          price.text);
    });

    Fluttertoast.showToast(
        msg: "wait we will save ur product.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    super.initState();
    storedNameAndPhone();
  }

  storedNameAndPhone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("name", widget.name);
    preferences.setString("phone", widget.phone);
    preferences.setString("collage", widget.collage);
  }

  /*navigateAndGetData(BuildContext context) async {
    final title =
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return EditScreen(widget.phone);
    }));

    

    setState(() {
      if (title != null) {
        productTitle.text = title.toString();
        producttitle = title;
      } else {
        productTitle.text = "";
      }
    });
  }*/
  showWarningToDeleteUnnessesaryItems() {
    return showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: AlertDialog(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Warning!!",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              content: Text(
                  " Kindly, Delete Items That Are Already Sold Out For Your Convenience. ",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.2,
                      fontWeight: FontWeight.w500)),
              contentPadding: EdgeInsets.all(13.3),
              actions: [
                FlatButton(
                    onPressed: () {
                      navigateAndGetData(context);
                    },
                    child: Text(
                      "Okay!",
                      style: TextStyle(color: Colors.blueAccent[900]),
                    )),
              ],
            ),
          );
        });
  }

  navigateAndGetData(BuildContext context) async {
    Navigator.of(context).pop();
    final SellModel title =
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return EditScreen(widget.phone);
    }));

    setState(() {
      if (title != null) {
        sellmodelobj = title;
        productDes.text = title.des.toString();
        price.text = title.price.toString();
      }
      if (title.product != null) {
        productTitle.text = title.product.toString();
        producttitle = title.product;
      } else {
        productTitle.text = "";
      }
    });
  }

  updateData(int index, var image) {
    if (producttitle != null &&
        productTitle.text != "" &&
        productDes.text != '' &&
        price.text != '' &&
        this.image != null) {
      DataManager().deleteUserData(index, image);
      uploadImage();
    } else {
      Fluttertoast.showToast(
          msg: "Kindly Check All Fields..All fields Are Required.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(producttitle);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title:
            Text(producttitle == null ? "Sell Your Item" : "Update Your Item"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Icon(Icons.edit),
              onTap: () {
                setState(() {
                  updateOrNot = true;
                });
                showWarningToDeleteUnnessesaryItems();
                // navigateAndGetData(context);
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        color: Colors.amber,
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
          if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Home(true, widget.name, widget.phone, widget.collage);
            }));
          } else {}
        },
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: productTitle,
                    enabled: producttitle != null && updateOrNot == true
                        ? false
                        : true,
                    decoration:
                        InputDecoration(labelText: "Enter Product Title"),
                  ),
                  TextField(
                    controller: productDes,
                    decoration:
                        InputDecoration(labelText: "Enter Product Description"),
                  ),
                  TextField(
                    controller: price,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: "Enter Price"),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10.2, 0, 0),
                      child: Text(
                        "upload Image Of Your product",
                        style: TextStyle(
                            fontSize: 12.2,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: image == null
                            ? Image.asset(
                                "assets/images/img.png",
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          msg: "Post",
                          onTap: () {
                            if (productTitle.text != "" &&
                                productDes.text != "" &&
                                price.text != "" &&
                                image != null &&
                                widget.name != "" &&
                                widget.collage != "" &&
                                widget.phone != "") {
                              sellmodelobj != null
                                  ? updateData(
                                      sellmodelobj!.index, sellmodelobj!.image)
                                  : uploadImage();
                              /**/
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Kindly Check All Fields..All fields Are Required.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          color: Colors.blue,
                        ),
                        CustomButton(
                          msg: "Cancel",
                          color: Colors.red,
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              image = null;
                              productTitle.clear();
                              productDes.clear();
                              price.clear();
                            });
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
