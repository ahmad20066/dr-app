// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:doctor_app/models/client.dart';
import 'package:doctor_app/screens/client_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CLient_Widget extends StatefulWidget {
  final List<Client> clients;
  final File image;
  final String name;
  int? age;
  final String gender;
  final String id;
  CLient_Widget(
      this.clients, this.name, this.image, this.age, this.gender, this.id);

  @override
  _CLient_WidgetState createState() => _CLient_WidgetState();
}

class _CLient_WidgetState extends State<CLient_Widget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(Client_Details_Screen.routename, arguments: widget.id);
      },
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            footer: Container(
              color: Colors.white,
              child: Text(
                widget.name,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            header: Container(
              padding: EdgeInsets.all(2),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    color: Colors.pink,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Age: ${widget.age}",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    widget.gender == "Male" ? Icons.male : Icons.female,
                    color: Colors.pink,
                  )
                ],
              ),
            ),
            child: Hero(
                tag: widget.id, child: Image(image: FileImage(widget.image))),
          ),
        ),
      ),
    );
  }
}
