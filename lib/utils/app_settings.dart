import 'package:flutter/material.dart';

class AppSettings {
  static ThemeData themeDataScreenStart = ThemeData(
    fontFamily: 'Roboto',
    primaryColor: Colors.white,
    primaryColorDark: Colors.white,);

  static Color colorScaffoldScreenStart = const Color.fromARGB(255, 229, 229, 229);

  static TextStyle textStyleScreenStartBottomNavigationBarItem = const TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
      fontFamily: 'RobotoLight');

  static TextStyle textStyleScreenStartAppBarTitle = const TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
      fontFamily: 'RobotoBold',
      fontSize: 20.0);

  static TextStyle newsListItemTitle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'RobotoLight',);

  static TextStyle newsListItemDate = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,);

  static TextStyle newsListItemSourceInfoName = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,);

  static TextStyle newsInfoTitle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'RobotoBold',
      fontSize: 20.0,);

  static TextStyle newsInfoDate = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,);

  static TextStyle newsCardSourceInfoName = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,);

  static TextStyle newsCardBody = const TextStyle (
      fontFamily: 'RobotoLight',
      fontStyle: FontStyle.italic,
      color: Colors.black38,);
  static TextStyle newsButtonOpenURL = const TextStyle(
      fontFamily: 'RobotoBold',);
}