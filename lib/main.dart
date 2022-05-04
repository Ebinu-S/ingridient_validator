import 'dart:io';
import 'package:project_ing_validator/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_ing_validator/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:project_ing_validator/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreamProvider<AppUser?>.value(
    value: AuthService().user,
    initialData: null,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Wrapper(),
    ),
  ));
}





