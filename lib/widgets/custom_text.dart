import 'package:flutter/material.dart';

import '../helpers/style.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;

  // name constructor that has a positional parameters with the text required
  // and the other parameters optional
  CustomText({
    Key? key,
    required this.text,
    required this.size,
    required this.color,
    required this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          //fontFamily: "Cursive",
          fontSize: size,
          color: color,
          fontWeight: weight),
    );
  }
}
