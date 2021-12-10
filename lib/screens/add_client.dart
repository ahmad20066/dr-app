// ignore_for_file: camel_case_types

import 'package:doctor_app/widget/Add_Widget.dart';
import 'package:flutter/material.dart';

class Add_Client extends StatelessWidget {
  static const routename = '/add';

  const Add_Client({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Add a client"),
      ),
      body: Add_Widget(),
    );
  }
}
