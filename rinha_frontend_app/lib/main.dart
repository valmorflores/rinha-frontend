import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rinhadefrontend/controller/application_controller.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ApplicationController applicationController =
      Get.put(ApplicationController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.light().copyWith(primary: Colors.black),
      ),
      debugShowCheckedModeBanner: false,
      home: SelectionArea(child: MyHomePage()),
    );
  }
}
