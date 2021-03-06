import 'package:covid/helpers/style.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String msg;
  final Function() onTap;
  final Color color;

  const CustomButton(
      {Key? key, required this.msg, required this.onTap, required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: grey.withOpacity(0.3),
                offset: Offset(2, 1),
                blurRadius: 2)
          ], color: color, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(14),
                child: CustomText(
                  text: msg,
                  color: white,
                  size: 12,
                  weight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
