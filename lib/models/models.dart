// Modello per la tabella Utenti
import 'package:mysql_client/mysql_client.dart';

class Utente {
  late int chatID;
  late String nomeCognome;

  Utente({required this.chatID, required this.nomeCognome});

  Utente.fromResultSetRow(ResultSetRow resultSetRow) {
    chatID = int.parse(resultSetRow.colByName("chatID") ?? '0');
    nomeCognome = resultSetRow.colByName('nomeCognome') ?? '';
  }
}

// Modello per la tabella Messaggi
class Messaggio {
  late int idMessaggio;
  late int chatID;
  late String testoMessaggio;

  Messaggio(
      {required this.idMessaggio,
      required this.chatID,
      required this.testoMessaggio});

  Messaggio.fromResultSetRow(ResultSetRow resultSetRow) {
    idMessaggio = int.parse(resultSetRow.colByName("idMessaggio") ?? '0');
    chatID = int.parse(resultSetRow.colByName('chatID') ?? '0');
    testoMessaggio = resultSetRow.colByName('testoMessaggio') ?? '';
  }
}

// Modello per la tabella Risposte
class Risposta {
  late int idRisposta;
  late int idMessaggio;
  late int chatID;
  late String testoRisposta;

  Risposta(
      {required this.idRisposta,
      required this.idMessaggio,
      required this.chatID,
      required this.testoRisposta});

  Risposta.fromResultSetRow(ResultSetRow resultSetRow) {
    idRisposta = int.parse(resultSetRow.colByName("idRisposta") ?? '0');
    idMessaggio = int.parse(resultSetRow.colByName('idMessaggio') ?? '0');
    chatID = int.parse(resultSetRow.colByName('chatID') ?? '0');
    testoRisposta = resultSetRow.colByName('testoRisposta') ?? '';
  }
}

// Modello per la tabella Prodotti
class Prodotto {
  late int idProdotto;
  late String nomeProdotto;

  Prodotto({required this.idProdotto, required this.nomeProdotto});

  Prodotto.fromResultSetRow(ResultSetRow resultSetRow) {
    idProdotto = int.parse(resultSetRow.colByName("idProdotto") ?? '0');
    nomeProdotto = resultSetRow.colByName('prodotto') ?? '';
  }
}

// Modello per la tabella Ordini
class Ordine {
  late int idOrdine;
  late int chatID;
  late int idProdotto;
  late int quantita;
  late DateTime data;

  Ordine({
    required this.idOrdine,
    required this.chatID,
    required this.idProdotto,
    required this.quantita,
    required this.data,
  });

  Ordine.fromResultSetRow(ResultSetRow resultSetRow) {
    idOrdine = int.parse(resultSetRow.colByName("idOrdine") ?? '0');
    chatID = int.parse(resultSetRow.colByName('chatID') ?? '0');
    idProdotto = int.parse(resultSetRow.colByName('idProdotto') ?? '0');
    quantita = int.parse(resultSetRow.colByName('quantita') ?? '0');
    data =
        DateTime.parse(resultSetRow.colByName('data') ?? '1970-01-01T00:00:00');
  }
}
