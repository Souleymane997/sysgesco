// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sysgesco/models/http.dart';

import '../models/config_sms_Model.dart';

class AppDatabase {
  AppDatabase._(); // constructeur privé

  static final AppDatabase instance =
      AppDatabase._(); // initialisation de l'instance

  // constantes
  static Database? _database;
  static const String tableHttp = "http";
  static const String tableConfig = "config";

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
        join(await getDatabasesPath(), 'FinalssDatabase.db'),
        onConfigure: onConfigure, onCreate: (db, version) async {
      // table Categories ..
      await db.execute('''
          CREATE TABLE $tableHttp(
            idHttp INTEGER PRIMARY KEY AUTOINCREMENT,
            cheminHttp TEXT 
          )
          ''');

      await db.execute('''
          CREATE TABLE $tableConfig(
            idconfig INTEGER PRIMARY KEY AUTOINCREMENT,
            poste TEXT,
            lycee TEXT 
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
    await db!.delete(tableHttp, where: 'cheminHttp = ?', whereArgs: [nom]);
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
    HttpModel(idHttp: 1, cheminHttp: "http://192.168.43.139/home/Api/"),
  ];
  //

  Future<HttpModel?> oneHttp(int i) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableHttp,
        columns: ['idHttp', 'cheminHttp'], where: 'idHttp = ?', whereArgs: [i]);

    if (maps.isNotEmpty) {
      return HttpModel.fromMap(maps.first);
    }
    return null;
  }

  void insertConfig(SmsModel element) async {
    final Database? db = await database;

    await db!.insert(tableConfig, element.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void updateConfig(SmsModel element) async {
    final Database? db = await database;
    await db!.update(tableConfig, element.toMap(),
        where: 'idconfig = ?', whereArgs: [element.idconfig]);
  }

  void deleteConfig(String nom) async {
    final Database? db = await database;
    await db!.delete(tableConfig, where: 'poste= ?', whereArgs: [nom]);
  }

  Future<List<SmsModel>> listConfig() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps =
        await db!.query(tableConfig, orderBy: 'idconfig desc');
    List<SmsModel> recipes = List.generate(maps.length, (i) {
      return SmsModel.fromMap(maps[i]);
    });

    if (recipes.isEmpty) {
      for (SmsModel cat in deftValue) {
        insertConfig(cat);
      }
    }
    return recipes;
  }

  List<SmsModel> deftValue = [
    SmsModel(
        idconfig: 1, poste: "Le Proviseur", lycee: "Lycée Privé Went Soong"),
  ];

  //

  Future<SmsModel?> oneConfig(int i) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableConfig,
        columns: ['idconfig', 'poste', 'lycee'],
        where: 'idconfig = ?',
        whereArgs: [i]);

    if (maps.isNotEmpty) {
      return SmsModel.fromMap(maps.first);
    }
    return null;
  }
}
