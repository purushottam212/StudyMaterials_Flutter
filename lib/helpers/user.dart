import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DataManager {
  final CollectionReference users = Firestore.instance.collection("users");
  final CollectionReference sellingInformation =
      Firestore.instance.collection("sellingInformation");

  Future<void> createUserData(String name, String password, String collage,
      String phone, String uid) async {
    return await users.document(uid).setData({
      'name': name,
      'password': password,
      'collage': collage,
      'phone': phone
    });
  }

  Future<void> sellingData(
      String id,
      String name,
      String collage,
      String phone,
      String imageUrl,
      String productTitle,
      String productDes,
      String price) async {
    return await sellingInformation.document().setData({
      'id': id,
      'name': name,
      'collage': collage,
      'phone': phone,
      'image': imageUrl,
      "product title": productTitle,
      "product Description": productDes,
      "price": price
    });
  }

  Future getUserByNumber() async {
    List<dynamic> itemList = [];

    try {
      await users.getDocuments().then((querySnapshot) => {
            querySnapshot.documents.forEach((element) {
              itemList.add(element.data);
            })
          });
      return itemList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getUserByNumberInSellInfo() async {
    List itemList = [];

    try {
      await sellingInformation.getDocuments().then((querySnapshot) => {
            querySnapshot.documents.forEach((element) {
              itemList.add(element.data);
            })
          });
      return itemList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  deleteUserData(int index, var imageUrl) async {
    FirebaseStorage.instance.getReferenceFromUrl(imageUrl).then((value) {
      value.delete().then((value) => Fluttertoast.showToast(
          msg: "Succesfully deleted Your Product",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0));
    });
    QuerySnapshot snapshot = await sellingInformation.getDocuments();
    snapshot.documents[index].reference.delete();
  }
}
