import 'dart:async';
import 'package:main/controller/sql_controller.dart';

class MessaggiRisposteController {
  final _sqlController = SqlController();

  Future<int> addMessage(String text) async {
    await _sqlController.connect();

    await _sqlController.query(
        "INSERT INTO Messaggi (testoMessaggio) VALUES (:text)", {'text': text});

    final response = await _sqlController.query("SELECT LAST_INSERT_ID();");

    return int.parse(response?.rows.first.colAt(0) ?? '-1');
  }

  Future<void> addResponse(
      int idMessaggio, int chatID, String testoRisposta) async {
    await _sqlController.connect();
    await _sqlController.query(
        "INSERT INTO Risposte (idMessaggio, chatId, testoRisposta) VALUES"
        " (:idMessaggio, :chatId, :testoRisposta)",
        {
          'idMessaggio': idMessaggio,
          'chatId': chatID,
          'testoRisposta': testoRisposta
        });
  }
}
