// ignore_for_file: camel_case_types

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class Db_Helper {
  // static delete() {
  //   sql.getDatabasesPath().then(
  //         (value) => sql.openDatabase(path.join(value, 'clientss.db'),
  //             onCreate: (value, version) {
  //           return value.execute('DROP TABLE IF EXISTS clients');
  //         }, version: 3),
  //       );
  // }

  static Future<sql.Database> database() {
    return sql.getDatabasesPath().then(
          (value) => sql.openDatabase(path.join(value, 'clientss.db'),
              onCreate: (value, version) {
            return value.execute(
                'CREATE TABLE clientss (id TEXT PRIMARY KEY,name TEXT,number INT,image TEXT,photos TEXT,gender TEXT,age INTEGER,visits TEXT)');
          }, version: 1),
        );
  }

  // static void _onUpgrade(sql.Database db, int oldVersion, int newVersion) {
  //   if (oldVersion < newVersion) {
  //     db.execute(
  //         "ALTER TABLE clients ADD COLUMN photos TEXT,gender TEXT,age INTEGER,visits TEXT;");
  //   }
  // }

  static Future<void> insert(
    String table,
    Map<String, dynamic> data,
  ) {
    return database().then(
        (value) => value.insert(table, data)); //inserting data to the database
  }

  static Future<List<Map<String, dynamic>>> getData(String table) {
    return database()
        .then((value) => value.query(table)); //getting data from the datatbase
  }
}
