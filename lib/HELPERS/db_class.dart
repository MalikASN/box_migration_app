import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:csv/csv.dart';
import 'package:path/path.dart';

class DbHelper {
  // final String csvpath;

  DbHelper();

  Future<void> initDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'boxes.db');

    await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS boxes(
            id INTEGER PRIMARY KEY,
            barcode TEXT,
            designation TEXT,
            geolocalisation TEXT,
            batchNumber TEXT
          )
        ''');
        //await insertDataFromCSV(db);
      },
      version: 1,
    );
  }

// Rest of the code remains the same

  /* Future<void> insertDataFromCSV(Database db) async {
    String csvData = await rootBundle.loadString(this.csvpath);
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);
    Batch batch = db.batch();
    //csvTable.removeAt(0);
    for (var row in csvTable) {
      batch.insert('boxes', {
        'id': row[0],
        'barcode': row[1],
        'designation': row[2],
        'geolocalisation': row[3],
      });
    }
    await batch.commit();
  }*/

  Future<bool> checkBoxExistance(String barcode) async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'boxes.db'),
    );

    List<Map<String, dynamic>> result = await database.rawQuery(
      "SELECT id FROM boxes WHERE barcode = '$barcode'",
    );
    database.close();

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getAllBoxes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bn = prefs.getString("batchNumber").toString();
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'boxes.db'),
    );

    List<Map<String, dynamic>> result = await database.rawQuery(
      "SELECT barcode, designation, geolocalisation FROM boxes WHERE batchNumber='$bn'",
    );

    database.close();

    return result;
  }

  Future<void> inserRow(
      String barcode, String geolocalisation, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'boxes.db'),
    );
    await database.insert('boxes', {
      "barcode": barcode,
      'designation': description,
      "geolocalisation": geolocalisation,
      "batchNumber": prefs.getString("batchNumber").toString()
    });

    database.close();
  }

  Future<int> countNumOfBoxes(String batch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Database database = await openDatabase(
      join(await getDatabasesPath(), 'boxes.db'),
    );
    List<Map<String, dynamic>> result = await database.rawQuery(
      "SELECT COUNT(*) AS count FROM boxes WHERE batchNumber='$batch'",
    );
    int count = result.isNotEmpty ? result.first['count'] as int : 0;
    return count;
  }
}
