import 'package:mysql_client/mysql_client.dart';

class SqlController {
  MySQLConnection? conn;

  Future<void> connect() async {
    if (conn?.connected == null) {
      conn ??= await MySQLConnection.createConnection(
        host: "albygone.it",
        port: 3306,
        userName: "telegram",
        password: "telegram",
        databaseName: "telegram", // optional
      );

      return conn?.connect();
    }
  }

  Future<IResultSet?> query(String query,
      [Map<String, dynamic>? params]) async {
    var result = await conn?.execute(query, params);
    return result;
  }
}
