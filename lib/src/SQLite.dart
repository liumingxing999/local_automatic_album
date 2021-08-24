import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

///  数据库的地址
String DBPath="automaticBackup.db";

///  传入sql语句并单独执行这一条语句
Future<void> RunSQL(String sql) async {
  var databasePath = await getDatabasesPath();
  String path = join(databasePath,DBPath);
  Database database = await openDatabase(path);
  await database.execute(sql);
  await database.close();
}
///  传入sql语句并单独执行这一条插入语句
Future<int> RunInsert(String sql) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, DBPath);
    Database database = await openDatabase(path);
    int result = await database.rawInsert(sql);
    await database.close();
    return result;
}
///  传入sql语句并单独执行这一条删除语句
Future<int> RunDelete(String sql) async {
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, DBPath);
  Database database = await openDatabase(path);
  int result = await database.rawDelete(sql);
  await database.close();
  return result;
}
/// 传入sql语句并单独执行这一条修改语句
Future<int> RunUpdate(String sql) async {
  var databasePath = await getDatabasesPath();
  String path = join(databasePath,DBPath);
  Database database = await openDatabase(path);
  int result = await database.rawUpdate(sql);
  await database.close();
  return result;
}
/// 传入sql语句并单独执行这一条搜索语句
Future<List<Map>> RunSelect(String sql) async {
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, DBPath);
  Database database = await openDatabase(path);
  List<Map> list = await database.rawQuery(sql);
  await database.close();
  return list;
}
/// 传入sql语句组并事务提交多条sql语句
Future<Object> RunBatch(List<String> sql) async {
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, DBPath);
  Database database = await openDatabase(path);
  var batch = database.batch();
  for(var i = 0; i < sql.length;i++){
    batch.execute(sql[i]);
  }
  var results = await batch.commit();
  await database.close();
  return results;
}