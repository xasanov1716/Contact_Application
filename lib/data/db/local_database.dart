import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
import '../../model/contact_model.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();

  LocalDatabase._init();

  factory LocalDatabase() {
    return getInstance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("contacts.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";

    await db.execute('''
    CREATE TABLE ${ContactModelFields.contactsTable} (
    ${ContactModelFields.id} $idType,
    ${ContactModelFields.name} $textType,
    ${ContactModelFields.surname} $textType,
    ${ContactModelFields.phone} $textType,
    ${ContactModelFields.photo} $textType
    )
    ''');

    debugPrint("-------DB----------CREATED---------");
  }

  static Future<ContactModelSql> insertContact(
      ContactModelSql contactsModelSql) async {
    final db = await getInstance.database;
    final int id = await db.insert(
        ContactModelFields.contactsTable, contactsModelSql.toJson());
    return contactsModelSql.copyWith(id: id);
  }

  static Future<List<ContactModelSql>> getAllContacts() async {
    List<ContactModelSql> allToContacts = [];
    final db = await getInstance.database;
    allToContacts = (await db.query(ContactModelFields.contactsTable))
        .map((e) => ContactModelSql.fromJson(e))
        .toList();

    return allToContacts;
  }

  static updateContactName({required int id, required String name}) async {
    final db = await getInstance.database;
    db.update(
      ContactModelFields.contactsTable,
      {ContactModelFields.name: name},
      where: "${ContactModelFields.id} = ?",
      whereArgs: [id],
    );
  }

  static updateContact({required ContactModelSql contactsModelSql}) async {
    final db = await getInstance.database;
    db.update(
      ContactModelFields.contactsTable,
      contactsModelSql.toJson(),
      where: "${ContactModelFields.id} = ?",
      whereArgs: [contactsModelSql.id],
    );
  }

  static deleteContact(int id) async {
    final db = await getInstance.database;
    db.delete(
      ContactModelFields.contactsTable,
      where: "${ContactModelFields.id} = ?",
      whereArgs: [id],
    );
  }

  static Future<List<ContactModelSql>> getContactsByLimit(int limit) async {
    List<ContactModelSql> allToDos = [];
    final db = await getInstance.database;
    allToDos = (await db.query(ContactModelFields.contactsTable,
        limit: limit, orderBy: "${ContactModelFields.name} ASC"))
        .map((e) => ContactModelSql.fromJson(e))
        .toList();

    return allToDos;
  }

  static Future<ContactModelSql?> getSingleContact(int id) async {
    List<ContactModelSql> contacts = [];
    final db = await getInstance.database;
    contacts = (await db.query(
      ContactModelFields.contactsTable,
      where: "${ContactModelFields.id} = ?",
      whereArgs: [id],
    ))
        .map((e) => ContactModelSql.fromJson(e))
        .toList();

    if (contacts.isNotEmpty) {
      return contacts.first;
    }
    return null;
  }

  static Future <List<ContactModelSql>> getSearch(String query)async{
    final db = await getInstance.database;
    final List<Map<String,dynamic>> maps = await db.query(ContactModelFields.contactsTable,
    where: "${ContactModelFields.name} like ?",
    whereArgs: ["$query%"]
    );
    return List.generate(maps.length, (index){
      print(maps[index]);
      return ContactModelSql.fromJson(maps[index]);
    });
  }

  static deleteContacts() async {
    final db = await getInstance.database;
    db.delete(
      ContactModelFields.contactsTable,
    );
  }

  static Future<List<ContactModelSql>> getContactsByAlphabet(
      String order) async {
    List<ContactModelSql> allContacts = [];
    final db = await getInstance.database;
    allContacts = (await db.query(ContactModelFields.contactsTable,
        orderBy: "${ContactModelFields.name} $order"))
        .map((e) => ContactModelSql.fromJson(e))
        .toList();
    return allContacts;
  }

  static Future<List<ContactModelSql>> getContactsByQuery(String query) async {
    List<ContactModelSql> allToDos = [];
    final db = await getInstance.database;
    allToDos = (await db.query(
      ContactModelFields.contactsTable,
      where: "${ContactModelFields.name} LIKE ?",
      whereArgs: [query],
    ))
        .map((e) => ContactModelSql.fromJson(e))
        .toList();
    return allToDos;
  }
}
