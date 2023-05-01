import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class PriceAlertDatabase {
  PriceAlertDatabase._();
  static final PriceAlertDatabase db = PriceAlertDatabase._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }
  initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "PriceAlert_database.db");
    return await openDatabase(
        path, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE PriceAlertData (id INTEGER PRIMARY KEY, coinName TEXT, coinImage TEXT, coinSymbol TEXT, coinPrice DOUBLE, isNotified INTEGER, priceUp INTEGER)');
        }
    );
  }

  Future getAllProducts() async {
    final db = await database;

    List list = await db.rawQuery('SELECT * FROM PriceAlertData');

    //print("@@@@@@@@@@"+list.toString());

    return list;
  }

  Future<int> countPriceAlertsLength() async {
    final db = await database;
    var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM PriceAlertData'));
    print('count  ==  $count');
    return count;
  }


  // Future<Product> getProductById(int id) async {
  //   final db = await database;
  //   var result = await db.query("Product", where: "id = ", whereArgs: [id]);
  //   return result.isNotEmpty ? Product.fromMap(result.first) : Null;
  // }

  insert(int id, String coinName, String coinImage, String coinSymbol, double coinPrice, int isNotified, int priceUp) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT INTO PriceAlertData ('id', 'coinName', 'coinImage', 'coinSymbol', 'coinPrice', 'isNotified', 'priceUp')"
            " VALUES (?, ?, ?, ?, ?, ?, ?)",
        [id, coinName, coinImage, coinSymbol, coinPrice, isNotified, priceUp]
    );
    //print("@@@@@@@@@@*********"+result.toString());
    return result;
  }

// update(Product product) async {
//   final db = await database;
//   var result = await db.update(
//       "Product", product.toMap(), where: "id = ?", whereArgs: [product.id]
//   );
//   return result;
// }

  delete(int id) async {
    final db = await database;
    //print("@@@@@@@@@@********* "+id.toString());
    db.delete("PriceAlertData", where: "id = ?", whereArgs: [id]);
  }

}
