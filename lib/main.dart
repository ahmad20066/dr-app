// ignore_for_file: prefer_const_constructors

import 'package:doctor_app/providers/clients_provider.dart';
import 'package:doctor_app/screens/add_client.dart';
import 'package:doctor_app/screens/client_details.dart';
import 'package:doctor_app/screens/clients_overview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Clients_Provider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'PtSans',
          primarySwatch: Colors.pink,
          // primaryColor: Colors.grey,
          // accentColor: Colors.grey,
        ),
        home: Clients_Overview(),
        routes: {
          Add_Client.routename: (context) => Add_Client(),
          Client_Details_Screen.routename: (context) => Client_Details_Screen()
        },
      ),
    );
  }
}
