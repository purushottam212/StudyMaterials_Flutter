import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NUMBER = "number";
  static const ID = "id";
  static const NAME = "name";
  static const SIRNAME = "sirname";
  static const COLLAGE = "collagename";

  String? _number;
  String? _id;
  String? _name;
  String? _sirname;
  String? _collage;

//  getters
  String get number => _number!;
  String get id => _id!;
  String get name => _name!;
  String get sirname => _sirname!;
  String get collage => _collage!;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _number = snapshot[NUMBER];
    _id = snapshot[ID];
    _name = snapshot[NAME];
    _sirname = snapshot[SIRNAME];
    _collage = snapshot[COLLAGE];
  }
}

class SellModel {
  var index;
  var product;
  var image;
  var des;
  var price;
  //SellModel(int index, displayData, displayData2);

  SellModel(var index, var product, var image, var des, var price) {
    this.index = index;
    this.product = product;
    this.image = image;
    this.des = des;
    this.price = price;
  }
}
