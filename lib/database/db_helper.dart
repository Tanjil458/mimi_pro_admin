import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/area.dart';
import '../models/credit.dart';
import '../models/customer.dart';
import '../models/delivery.dart';
import '../models/employee.dart';
import '../models/order.dart';
import '../models/product.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'mimi_pro.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE areas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_code TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        area_id INTEGER,
        FOREIGN KEY (area_id) REFERENCES areas (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        stock INTEGER NOT NULL DEFAULT 0,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_code TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        phone TEXT,
        role TEXT,
        salary REAL DEFAULT 0,
        salary_type TEXT DEFAULT 'Monthly',
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        total REAL NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customers (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE deliveries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        employee_id INTEGER,
        status TEXT NOT NULL DEFAULT 'assigned',
        delivery_date TEXT,
        FOREIGN KEY (order_id) REFERENCES orders (id),
        FOREIGN KEY (employee_id) REFERENCES employees (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE credits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (customer_id) REFERENCES customers (id)
      )
    ''');
  }

  // ─────────────────────── AREAS ───────────────────────

  static Future<int> insertArea(Area area) async {
    final db = await database;
    return db.insert('areas', area.toMap()..remove('id'));
  }

  static Future<List<Area>> getAreas() async {
    final db = await database;
    final maps = await db.query('areas');
    return maps.map(Area.fromMap).toList();
  }

  static Future<int> updateArea(Area area) async {
    final db = await database;
    return db.update(
      'areas',
      area.toMap(),
      where: 'id = ?',
      whereArgs: [area.id],
    );
  }

  static Future<int> deleteArea(int id) async {
    final db = await database;
    return db.delete('areas', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────── CUSTOMERS ───────────────────────

  /// Generates a unique ID like `cus-20260304153012-001`
  static Future<String> generateCustomerId() async {
    final now = DateTime.now();
    final prefix =
        'cus-'
        '${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '-'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
    final db = await database;
    // Count ALL customers so the suffix is always sequential (001, 002, 003…)
    final result = await db.rawQuery('SELECT COUNT(*) AS cnt FROM customers');
    final count = Sqflite.firstIntValue(result) ?? 0;
    return '$prefix-${(count + 1).toString().padLeft(3, '0')}';
  }

  static Future<int> insertCustomer(Customer customer) async {
    final db = await database;
    return db.insert('customers', customer.toMap()..remove('id'));
  }

  static Future<List<Customer>> getCustomers() async {
    final db = await database;
    final maps = await db.query('customers');
    return maps.map(Customer.fromMap).toList();
  }

  static Future<int> updateCustomer(Customer customer) async {
    final db = await database;
    return db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  static Future<int> deleteCustomer(int id) async {
    final db = await database;
    return db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────── PRODUCTS ───────────────────────

  static Future<int> insertProduct(Product product) async {
    final db = await database;
    return db.insert('products', product.toMap()..remove('id'));
  }

  static Future<List<Product>> getProducts() async {
    final db = await database;
    final maps = await db.query('products');
    return maps.map(Product.fromMap).toList();
  }

  static Future<int> updateProduct(Product product) async {
    final db = await database;
    return db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  static Future<int> deleteProduct(int id) async {
    final db = await database;
    return db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────── EMPLOYEES ───────────────────────

  /// Generates a unique ID like `EMP-20260304-153012`
  static Future<String> generateEmployeeId() async {
    final now = DateTime.now();
    final prefix =
        'EMP-'
        '${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '-'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
    final db = await database;
    // Count ALL employees so the suffix is always sequential (001, 002, 003…)
    final result = await db.rawQuery('SELECT COUNT(*) AS cnt FROM employees');
    final count = Sqflite.firstIntValue(result) ?? 0;
    return '$prefix-${(count + 1).toString().padLeft(3, '0')}';
  }

  static Future<int> insertEmployee(Employee employee) async {
    final db = await database;
    return db.insert('employees', employee.toMap()..remove('id'));
  }

  static Future<List<Employee>> getEmployees() async {
    final db = await database;
    final maps = await db.query('employees');
    return maps.map(Employee.fromMap).toList();
  }

  static Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    return db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  static Future<int> deleteEmployee(int id) async {
    final db = await database;
    return db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────── ORDERS ───────────────────────

  static Future<int> insertOrder(Order order) async {
    final db = await database;
    return db.insert('orders', order.toMap()..remove('id'));
  }

  static Future<List<Order>> getOrders() async {
    final db = await database;
    final maps = await db.query('orders', orderBy: 'created_at DESC');
    return maps.map(Order.fromMap).toList();
  }

  static Future<List<Order>> getOrdersByCustomer(int customerId) async {
    final db = await database;
    final maps = await db.query(
      'orders',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'created_at DESC',
    );
    return maps.map(Order.fromMap).toList();
  }

  static Future<int> updateOrder(Order order) async {
    final db = await database;
    return db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  static Future<int> deleteOrder(int id) async {
    final db = await database;
    return db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────── DELIVERIES ───────────────────────

  static Future<int> insertDelivery(Delivery delivery) async {
    final db = await database;
    return db.insert('deliveries', delivery.toMap()..remove('id'));
  }

  static Future<List<Delivery>> getDeliveries() async {
    final db = await database;
    final maps = await db.query('deliveries');
    return maps.map(Delivery.fromMap).toList();
  }

  static Future<List<Delivery>> getDeliveriesByEmployee(int employeeId) async {
    final db = await database;
    final maps = await db.query(
      'deliveries',
      where: 'employee_id = ?',
      whereArgs: [employeeId],
    );
    return maps.map(Delivery.fromMap).toList();
  }

  static Future<int> updateDelivery(Delivery delivery) async {
    final db = await database;
    return db.update(
      'deliveries',
      delivery.toMap(),
      where: 'id = ?',
      whereArgs: [delivery.id],
    );
  }

  static Future<int> deleteDelivery(int id) async {
    final db = await database;
    return db.delete('deliveries', where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────── CREDITS ───────────────────────

  static Future<int> insertCredit(Credit credit) async {
    final db = await database;
    return db.insert('credits', credit.toMap()..remove('id'));
  }

  static Future<List<Credit>> getCredits() async {
    final db = await database;
    final maps = await db.query('credits', orderBy: 'date DESC');
    return maps.map(Credit.fromMap).toList();
  }

  static Future<List<Credit>> getCreditsByCustomer(int customerId) async {
    final db = await database;
    final maps = await db.query(
      'credits',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'date DESC',
    );
    return maps.map(Credit.fromMap).toList();
  }

  static Future<double> getTotalCreditByCustomer(int customerId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM credits WHERE customer_id = ?',
      [customerId],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  static Future<int> updateCredit(Credit credit) async {
    final db = await database;
    return db.update(
      'credits',
      credit.toMap(),
      where: 'id = ?',
      whereArgs: [credit.id],
    );
  }

  static Future<int> deleteCredit(int id) async {
    final db = await database;
    return db.delete('credits', where: 'id = ?', whereArgs: [id]);
  }
}
