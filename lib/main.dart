import 'package:flutter/material.dart';
import 'utilities/constants.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Text(
          'DOCYARD',
          style: kDocyardStyle,
        ),
      ),
    );
  }
}
