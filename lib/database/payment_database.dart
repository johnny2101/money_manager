import 'package:money_manager/database/category.dart';
import 'package:money_manager/database/payment.dart';
import 'package:sqflite/sqflite.dart';

class PaymentDatabase {
  static final PaymentDatabase instance = PaymentDatabase._init();

  static Database? _database;

  PaymentDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('payments.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(path,
        version: 10, onCreate: _createDB /* , onUpgrade: _updateDB */);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    final boolType = 'BOOLEAN NOT NULL';
    final intType = 'INTEGER NOT NULL';
    final doubleType = 'DOUBLE NOT NULL';
    final textType = 'TEXT NOT NULL';
    final bigIntType = 'BIGINT NOT NULL';

    await db.execute('''
      CREATE TABLE $tablePayments (
        ${PaymentFields.id} $idType,
        ${PaymentFields.type} $textType,
        ${PaymentFields.import} $doubleType,
        ${PaymentFields.title} $textType,
        ${PaymentFields.description} $textType,
        ${PaymentFields.createdTime} $textType

      )
''');

    await db.execute('''
      CREATE TABLE $tableCategories (
        ${CategoryFields.id} $idType,
        ${CategoryFields.category} $textType,
        ${CategoryFields.color} $intType
      )''');
  }

  Future _updateDB(Database db, int version, int last) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    final boolType = 'BOOLEAN NOT NULL';
    final intType = 'BIGINT NOT NULL';
    final doubleType = 'DOUBLE NOT NULL';
    final textType = 'TEXT NOT NULL';

    /* await db.execute('''
      CREATE TABLE $tablePayments (
        ${PaymentFields.id} $idType,
        ${PaymentFields.type} $textType,
        ${PaymentFields.import} $doubleType,
        ${PaymentFields.title} $textType,
        ${PaymentFields.description} $textType,
        ${PaymentFields.createdTime} $textType

      )
'''); */
    await db.execute('''
      CREATE TABLE $tableCategories (
        ${CategoryFields.id} $idType,
        ${CategoryFields.category} $textType,
        ${CategoryFields.color} $intType
      )''');
  }

  Future<Payment> create(Payment payment) async {
    final db = await instance.database;

    final id = await db.insert(tablePayments, payment.toJson());
    return payment.copy(id: id);
  }

  Future<Payment> readPayment(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePayments,
      columns: PaymentFields.values,
      where: '${PaymentFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Payment.fromJson(maps.first);
    } else {
      throw Exception("id $id not found");
    }
  }

  Future<List<Payment>> readAllPayments() async {
    final db = await instance.database;

    final orderBy = '${PaymentFields.createdTime} ASC';

    final result = await db.query(tablePayments, orderBy: orderBy);

    return result.map((json) => Payment.fromJson(json)).toList();
  }

  Future<int> update(Payment payment) async {
    final db = await instance.database;

    return db.update(tablePayments, payment.toJson(),
        where: '${PaymentFields.id} = ?', whereArgs: [payment.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db.delete(tablePayments,
        where: '${PaymentFields.id} = ?', whereArgs: [id]);
  }

  //CATEGORY

  Future<Category> createCategory(Category category) async {
    final db = await instance.database;

    final id = await db.insert(tableCategories, category.toJson());
    return category.copy(id: id);
  }

  Future<Category> readCategory(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCategories,
      columns: CategoryFields.values,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      throw Exception("id $id not found");
    }
  }

  Future<List<Category>> readAllCategories() async {
    final db = await instance.database;

    final orderBy = '${CategoryFields.category} ASC';

    final result = await db.query(tableCategories, orderBy: orderBy);

    return result.map((json) => Category.fromJson(json)).toList();
  }

  Future<int> updateCategory(Category category) async {
    final db = await instance.database;

    return db.update(tableCategories, category.toJson(),
        where: '${CategoryFields.id} = ?', whereArgs: [category.id]);
  }

  Future<int> deleteCategory(int id) async {
    final db = await instance.database;

    return db.delete(tableCategories,
        where: '${CategoryFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {}
}
