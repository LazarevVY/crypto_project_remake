import 'package:flutter/material.dart';
import 'utils/app_settings.dart';
import 'screens/screen_start.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScreenStart(),
      theme: AppSettings.themeDataScreenStart,
    );
  }
}
