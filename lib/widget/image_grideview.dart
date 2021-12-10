// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';

class Images_Gridview extends StatefulWidget {
  final List? images;
  Images_Gridview(this.images);

  @override
  _Images_GridviewState createState() => _Images_GridviewState();
}

class _Images_GridviewState extends State<Images_Gridview> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.images!.isEmpty ? 0 : 200,
      child: GridView.builder(
        itemCount: widget.images!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: FullScreenWidget(
              child: Image(
                image: FileImage(File(widget.images![index])),
              ),
            ),
          );
        },
      ),
    );
  }
}
