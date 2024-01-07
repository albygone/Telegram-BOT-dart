import 'dart:async';
import 'package:main/controller/bar_controller.dart';
import 'package:main/controller/telegram_bot_controller.dart';
import 'package:main/controller/user_controller.dart';
import 'package:main/handlers/user_handler.dart';
import 'package:main/models/models.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

class BarHandler {
  BarHandler(TelegramBotController controller) {
    _controller = controller;
    userHandler = UserHandler(_controller);
  }

  final userController = UserController();
  late UserHandler userHandler;

  late TelegramBotController _controller;
  late StreamSubscription _streamSubscription;

  final _barController = BarController();

  Prodotto? _product;

  Future<void> start(TeleDartMessage? message) async {
    try {
      if (await userController.checkUser(message!.chat.id)) {
        var prodotti = await getList();

        message.reply(
            'Benvenuto nel serivizio di prenotazioni bar, cosa vuoi ordinare?',
            replyMarkup: _controller.buildInlineKeyboard(prodotti));
      } else {
        message.reply(
            "Ciao ${message.chat.firstName}, registrati come utente per poter utilizzare il bot");

        userHandler.addUser(message);
      }
    } catch (e) {
      message?.reply('Errore, riprova più tardi');
    }
  }

  Future<void> handleResponse(TeleDartMessage? message, int productId) async {
    try {
      if (productId == -1) return;

      final prodotto = await _barController.getProdotto(productId);

      if (prodotto.idProdotto == -1) return;

      _product = prodotto;

      askForQta(message);
    } catch (e) {
      message?.reply('Errore, riprova più tardi');
    }
  }

  Future<List<List<(String, String)>>> getList() async {
    List<List<(String, String)>> list = [];

    final prodotti = await _barController.getProdotti();

    for (var prodotto in prodotti) {
      list.add([(prodotto.nomeProdotto, 'product_${prodotto.idProdotto}')]);
    }

    return list;
  }

  Future<void> askForQta(TeleDartMessage? message) async {
    int id = message?.chat.id ?? 0;
    if (id != 0) {
      _streamSubscription = _controller.addMessageHandler(handleQta);
      message?.reply("Inserisci la quantità desiderata");
    } else {
      message?.reply('Errore, riprova più tardi');
    }
  }

  Future<void> handleQta(TeleDartMessage message, TeleDart controller) async {
    final qta = int.tryParse(message.text ?? '');

    if (qta != null && _product != null) {
      await _barController.addOrdine(
          message.chat.id, _product?.idProdotto ?? 0, qta.toString());

      message.reply('Hai ordinato ${_product?.nomeProdotto} - $qta');

      _streamSubscription.cancel();

      _product = null;
    } else {
      message.reply('Formato non corretto riprova');
    }
  }
}
