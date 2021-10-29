import 'package:covid/helpers/user.dart';
import 'package:covid/models/user.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  String phone;
  EditScreen(this.phone);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  List? data;
  bool flag = false;
  List displayData = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getData();
    print(widget.phone);
  }

  getData() async {
    data = await DataManager().getUserByNumberInSellInfo();

    checkifProductsExists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Edit Your Products"),
        elevation: 7.8,
      ),
      backgroundColor: Colors.grey[300],
      body: Container(
          child: displayData.length != 0
              ? ListView.builder(
                  itemCount: displayData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Stack(
                          children: [
                            Image.network(
                              displayData[index]['image'],
                              height: MediaQuery.of(context).size.height * 0.32,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext? context,
                                  Widget? child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child!;
                                return Center(
                                  child: CircularProgressIndicator(
                                      /*value: loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,*/
                                      ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                displayData[index]['product title'],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.9,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            /*Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12.2, 230.0, 0.0, 0.0),
                              child: Text(
                                "price: " + displayData[index]['price'] + "rs",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.9,
                                    fontWeight: FontWeight.bold),
                              ),
                            )*/
                            /* Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12.2,246.0, 0.0, 0.0),*/
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      /* AddItem("","","").updateData(
                                            index, displayData[index]['image']);
                                        Navigator.of(context).pop(
                                            displayData[index]['product title']);*/

                                      Navigator.of(context).pop(SellModel(
                                          index,
                                          displayData[index]['product title'],
                                          displayData[index]['image'],
                                          displayData[index]
                                              ['product Description'],
                                          displayData[index]['price']));
                                    },
                                    child: Icon(
                                      Icons.mode_edit,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                  InkWell(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      print(displayData[index]['image']);
                                      showDeleteDialog(context, index);
                                    },
                                  )
                                ],
                              ),
                            ),
                            //)
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                      ),
                    );
                  })
              : Center(
                  child: Text("No Products"),
                )),
    );
  }

  showDeleteDialog(BuildContext context, int index) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Warning!!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Are You Sure to Delete this item?",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            contentPadding: const EdgeInsets.all(20.0),
            actions: [
              Container(
                height: 2.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                      onPressed: () {
                        DataManager()
                            .deleteUserData(index, displayData[index]['image']);
                        Navigator.of(context).pop();
                        setState(() {
                          displayData.removeAt(index);
                        });
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      )),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("No",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )))
                ],
              ),
            ],
          );
        });
  }

  checkifProductsExists() async {
    print(data!.length);
    for (var i = 0; i < data!.length; i++) {
      if (widget.phone == data![i]['phone']) {
        setState(() {
          flag = true;
          displayData.add(data![i]);
        });
      }
    }
  }
}
