// ignore_for_file: camel_case_types, prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:doctor_app/providers/clients_provider.dart';
import 'package:doctor_app/screens/add_client.dart';
import 'package:doctor_app/screens/clients_overview.dart';
import 'package:doctor_app/widget/image_grideview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';

class Client_Details_Screen extends StatefulWidget {
  static const routename = '/details';

  @override
  State<Client_Details_Screen> createState() => _Client_Details_ScreenState();
}

class _Client_Details_ScreenState extends State<Client_Details_Screen> {
  Widget BuildContainer(String value, IconData icon) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.pink,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientId = ModalRoute.of(context)!.settings.arguments as String;
    if (clientId != null) {
      final client =
          Provider.of<Clients_Provider>(context, listen: false).find(clientId);
      final List photos = jsonDecode(client.images);
      final Map<String, dynamic> visits = jsonDecode(client.visits);

      bool isLoading = false;

      return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(client.name),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(Add_Client.routename, arguments: clientId);
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text(
                              "Are you sure you want to delete this client?"),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);

                                  Navigator.of(context).pop(true);

                                  Provider.of<Clients_Provider>(context,
                                          listen: false)
                                      .delete(clientId)
                                      .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Item successfully dismissed")),
                                    );
                                  });
                                },
                                child: Text("Yes")),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  print("ss");
                                },
                                child: Text("No")),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FullScreenWidget(
                          child: Hero(
                              tag: clientId,
                              child: Image(image: FileImage(client.image!))))),
                ),
                SizedBox(
                  height: 20,
                ),
                BuildContainer("name : ${client.name} ", Icons.person),
                SizedBox(
                  height: 20,
                ),
                if (client.number != null)
                  BuildContainer("Number : ${client.number}", Icons.phone),
                if (client.number != null)
                  SizedBox(
                    height: 20,
                  ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          " Age : " + "${client.age}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BuildContainer("Gender : ${client.gender}", Icons.male),
                SizedBox(
                  height: 20,
                ),
                Images_Gridview(photos),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                      itemCount: visits.length,
                      itemBuilder: (context, i) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "visit  ${i + 1} :",
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      "${visits["${i + 1}"]}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
