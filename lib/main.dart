import 'dart:convert';
import 'package:ampiiiy/coins_screen.dart';
import 'package:ampiiiy/crypto_detailpage.dart';
import 'package:ampiiiy/home_page.dart';
import 'package:flutter/material.dart';
import 'web_socket_service.dart';
import 'crypto_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ampiy Crypto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
