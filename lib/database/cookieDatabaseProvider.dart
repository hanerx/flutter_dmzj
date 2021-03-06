import 'package:dcomic/utils/log_output.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import 'databaseCommon.dart';

class CookieDatabaseProvider {
  final String name;


  Database _database;
  Logger logger = Logger(
      filter: ReleaseFilter(),
      printer: PrettyPrinter(),
      output: ConsoleLogOutput());

  CookieDatabaseProvider(this.name);

  Future<Database> get db async {
    if (_database == null) {
      _database = await DatabaseCommon.initDatabase();
    }
    return _database;
  }

  Future<void> insert<T>(String configName, dynamic configValue) async {
    var batch = (await db).batch();
    batch.delete("cookies", where: "key='$configName' AND provider='$name'");
    switch (T) {
      case String:
        batch.insert(
            "cookies", {'key': '$configName', 'value': configValue,'provider':name});
        break;
      case bool:
        batch.insert("cookies",
            {'key': '$configName', 'value': configValue ? '1' : '0','provider':name});
        break;
      default:
        batch.insert("cookies",
            {'key': '$configName', 'value': configValue.toString(),'provider':name});
        break;
    }
    await batch.commit();
  }

  Future get<T>(String configName, {T defaultValue}) async {
    var batch = (await db).batch();
    batch.query("cookies", where: "key='$configName' AND provider='$name'");
    var result = await batch.commit()as List<dynamic>;
    try {
      switch (T) {
        case String:
          return result.first[0]['value'].toString();
        case bool:
          return result.first[0]['value'] == '1';
        case int:
          return int.parse(result.first[0]['value']);
        case double:
          return double.parse(result.first[0]['value']);
        default:
          return result.first[0]['value'];
      }
    } catch (e,s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'cookieGetFailed:$configName, provider: $name');
      logger.w(
          'action: cookieGetFailed, name: $name, cookieName: $configName, exception: $e');
    }
    return defaultValue;
  }

  Future<List> getAll()async{
    var batch = (await db).batch();
    batch.query("cookies",where: "provider='$name'");
    return await batch.commit();
  }
}