// ignore_for_file: unused_field, prefer_final_fields, camel_case_types, non_constant_identifier_names

import 'dart:io';

import 'package:doctor_app/helpers/dbhelper.dart';
import 'package:doctor_app/models/client.dart';
import 'package:flutter/cupertino.dart';

class Clients_Provider with ChangeNotifier {
  List<Client> _items = [
    //Client(DateTime.now().toString(), 'aaa', 1111, null, null, 'male', 12, null)
  ];
  List<Client> get items {
    return [..._items];
  }

  Future<void> addData(String id, String name, int? num, File image,
      String photos, String gender, int age, String visits) {
    final newClient = Client(id, name, num, image, photos, gender, age, visits);
    _items.add(newClient);
    notifyListeners();
    return Db_Helper.insert(
        'clientss',
        ({
          'id': newClient.id,
          "name": newClient.name,
          'number': newClient.number,
          'image': newClient.image!.path,
          'photos': newClient.images,
          'gender': newClient.gender,
          'age': newClient.age,
          'visits': newClient.visits,
        }));
  }

  Future<void> getData() {
    return Db_Helper.getData('clientss').then((value) {
      //final List<Client> clientlist = [];
      _items = value
          .map((e) => Client(e['id'], e['name'], e['number'], File(e['image']),
              e['photos'], e['gender'], e['age'], e['visits']))
          .toList();
      notifyListeners();
    }).then((value) {});
  }

  Client find(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future update(String id, Client newProduct) {
    final index = _items.indexWhere((element) => element.id == id);
    _items[index] = newProduct;
    notifyListeners();
    return Db_Helper.database()
        .then((value) => value.rawUpdate('''UPDATE clientss
    SET name = ?,number = ?,image = ?,photos = ?,gender = ?,age = ?,visits = ?
    WHERE id = ? ''', [
              (newProduct.name),
              newProduct.number,
              (newProduct.image!.path),
              newProduct.images,
              newProduct.gender,
              newProduct.age,
              newProduct.visits,
              newProduct.id
            ]));
  }

  List<Client> Search(String n) {
    return _items.where((element) => element.name.contains(n)).toList();
  }

  Future delete(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    return Db_Helper.database()
        .then((value) => value.rawDelete('''DELETE FROM clientss
      WHERE id = ?
    ''', [id]));
  }
}
