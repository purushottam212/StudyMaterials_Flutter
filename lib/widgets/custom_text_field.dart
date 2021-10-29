import 'package:covid/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? labelText;
  final Icon? icon;
  final bool? secure;
  const CustomTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.labelText,
      this.keyboardType,
      this.icon,
      this.secure})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      child: Container(
        decoration: BoxDecoration(
            color: white,
            border: Border.all(color: black, width: 0.2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: grey.withOpacity(0.3),
                  offset: Offset(2, 1),
                  blurRadius: 2)
            ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextField(
            keyboardType: keyboardType,
            obscureText: secure!,
            controller: controller,
            decoration: InputDecoration(
                icon: icon,
                border: InputBorder.none,
                hintText: hintText,
                labelText: labelText,
                hintStyle:
                    TextStyle(color: grey, fontFamily: "Sen", fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
