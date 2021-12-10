import 'dart:io';

class Client {
  final String? id;
  final String name;

  final int? number;
  final File? image;
  final String images;
  final String gender;
  final int? age;
  final String visits;

  Client(this.id, this.name, this.number, this.image, this.images, this.gender,
      this.age, this.visits);
}
