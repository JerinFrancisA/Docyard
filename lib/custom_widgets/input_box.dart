import 'package:doc_yard/utilities/constants.dart';
import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  var input;

  @override
  _InputBoxState createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: kDocyardStyle.copyWith(
        letterSpacing: 4.0,
        fontWeight: FontWeight.w700,
        fontSize: 24.0,
      ),
      cursorColor: kDocyardButton1Color,
      decoration: InputDecoration(
        labelText: 'Category',
        labelStyle: kDocyardStyle.copyWith(
          letterSpacing: 3.0,
        ),
        hintText: 'Enter new category name',
        hintStyle: kDocyardStyle.copyWith(
          fontSize: 14.0,
          letterSpacing: 3.0,
        ),
        filled: true,
        fillColor: kDocyardButton1Color.withOpacity(0.4),
        contentPadding: EdgeInsets.all(6.0),
        border: InputBorder.none,
      ),
      onChanged: (val) {
        setState(() {
          widget.input = val;
        });
      },
    );
  }
}
