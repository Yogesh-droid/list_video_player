import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_list_player/views/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}
