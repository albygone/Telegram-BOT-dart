import 'dart:async';
import 'package:main/controller/sql_controller.dart';
import 'package:main/models/models.dart';

class BarController {
  final _sqlController = SqlController();

  Future<List<Prodotto>> getProdotti() async {
    await _sqlController.connect();

    final response = await _sqlController.query("SELECT * FROM Prodotti");

    var prodotti = <Prodotto>[];

    response?.rows.forEach((element) {
      prodotti.add(Prodotto.fromResultSetRow(element));
    });

    return prodotti;
  }

  Future<Prodotto> getProdotto(int productId) async {
    await _sqlController.connect();

    final response = await _sqlController.query(
        "SELECT * FROM Prodotti WHERE idProdotto = :idProdotto",
        {'idProdotto': productId});

    final row = response?.rows.first;

    return row != null
        ? Prodotto.fromResultSetRow(row)
        : Prodotto(idProdotto: -1, nomeProdotto: '');
  }

  Future<void> addOrdine(int chatId, int idProdotto, String quantita) async {
    if (idProdotto == -1) return;

    await _sqlController.connect();
    await _sqlController.query(
        "INSERT INTO Ordini (chatId, idProdotto, quantita, data) VALUES"
        " (:chatId, :idProdotto, :quantita, CURDATE())",
        {'chatId': chatId, 'idProdotto': idProdotto, 'quantita': quantita});
  }
}
