// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sysgesco/models/http.dart';


class AppDatabase {
  AppDatabase._(); // constructeur privé

  static final AppDatabase instance =
      AppDatabase._(); // initialisation de l'instance

  // constantes
  static Database? _database;
  static const String tableHttp = "http";
  

  Future<Database?> get database async {
    //ignore: unnecessary_null_comparison
    //if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  static Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = OFF');
  }
  // initialisation de la base de donnée ..
  Future<Database> initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
        join(await getDatabasesPath(), 'FinaleDatabase.db'),
        onConfigure: onConfigure, onCreate: (db, version) async {
      // table Categories ..
      await db.execute('''
          CREATE TABLE $tableHttp(
            idHttp INTEGER PRIMARY KEY AUTOINCREMENT,
            cheminHttp TEXT 
          )
          ''');

    }, version: 1);
  }

  // fermer la base donnée en sortant de l'application
  void closeDatabase() async {
    final Database? db = await database;
    await db!.close();
  }



  void insertHttp(HttpModel element) async {
    final Database? db = await database;

    await db!.insert(tableHttp, element.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void updateHttp(HttpModel element) async {
    final Database? db = await database;
    await db!.update(tableHttp, element.toMap(),
        where: 'idHttp = ?', whereArgs: [element.idHttp]);
  }

  void deleteHttp(String nom) async {
    final Database? db = await database;
    await db!
        .delete(tableHttp, where: 'cheminHttp = ?', whereArgs: [nom]);
  }

  Future<List<HttpModel>> listHttp() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps =
        await db!.query(tableHttp, orderBy: 'idHttp desc');
    List<HttpModel> recipes = List.generate(maps.length, (i) {
      return HttpModel.fromMap(maps[i]);
    });

    if (recipes.isEmpty) {
      for (HttpModel cate in defaultValue) {
        insertHttp(cate);
      }
    }
    return recipes;
  }

  List<HttpModel> defaultValue = [
    HttpModel(idHttp: 1, cheminHttp: "http://192.168.43.139/Api/"),
  ];

  //


  Future<HttpModel?> oneHttp(int i) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableHttp,
        columns: ['idHttp', 'cheminHttp'],
        where: 'idHttp = ?',
        whereArgs: [i]);

    if (maps.isNotEmpty) {
      return HttpModel.fromMap(maps.first);
    }
    return null;
  }

}
