import 'dart:async';
import 'package:main/controller/sql_controller.dart';

class UserController {
  final _sqlController = SqlController();

  Future<void> addUser(int id, String nameSurname) async {
    if (nameSurname != '') {
      if (!(await checkUser(id))) {
        await _sqlController.connect();
        await _sqlController.query(
            "INSERT INTO Utenti (chatID, nomeCognome) VALUES (:id, :nomeCognome)",
            {'id': id, 'nomeCognome': nameSurname});
      } else {
        await _sqlController.connect();
        await _sqlController.query(
            "UPDATE Utenti SET nomeCognome = :nomeCognome WHERE chatID = :id",
            {'id': id, 'nomeCognome': nameSurname});
      }
    } else {
      return Future.error('Inserisci nome e cognome');
    }
  }

  Future<bool> checkUser(int id) async {
    await _sqlController.connect();
    var result = await _sqlController
        .query("SELECT * FROM Utenti WHERE chatID = :id", {'id': id});

    return !(result == null || result.numOfRows == 0);
  }

  Future<List<String>> getChatIds() async {
    await _sqlController.connect();
    var result = await _sqlController.query("SELECT chatID FROM `Utenti`", {});

    List<String> chatIdS = [];

    if (result != null) {
      for (var row in result.rows) {
        chatIdS.add(row.colByName('chatID') ?? '');
      }
    }

    return chatIdS;
  }
}
