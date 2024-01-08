import 'dart:async';
import 'package:main/controller/messaggi_risposte_controller.dart';
import 'package:main/controller/telegram_bot_controller.dart';
import 'package:main/controller/user_controller.dart';
import 'package:main/handlers/user_handler.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

class AutoMsgHandler {
  AutoMsgHandler(TelegramBotController controller) {
    _controller = controller;
    userHandler = UserHandler(_controller);
  }

  final userController = UserController();
  late UserHandler userHandler;

  late TelegramBotController _controller;
  late StreamSubscription _streamSubscription;

  final _messaggiRisposteController = MessaggiRisposteController();

  Future<void> start(TeleDartMessage? message) async {
    try {
      if (await userController.checkUser(message!.chat.id)) {
        message.reply(
            'Benvenuto nel serivizio di invio di messaggi automatici, quale messaggio vuoi inviare?');
        _streamSubscription = _controller.addMessageHandler(askAndSendMessage);
      } else {
        message.reply(
            "Ciao ${message.chat.firstName}, registrati come utente per poter utilizzare il bot");

        userHandler.addUser(message);
      }
    } catch (e) {
      message?.reply('Errore, riprova più tardi');
    }
  }

  Future<void> askAndSendMessage(
      TeleDartMessage message, TeleDart controller) async {
    String text = message.text ?? '';

    if (text != '') {
      int id = await sendMessages(text);

      await _streamSubscription.cancel();

      if (id != -1) await getResponse(id);
    }
  }

  Future<int> sendMessages(String text) async {
    List<String> chatIdS = await userController.getChatIds();
    int id = -1;

    if (chatIdS.isEmpty) {
      return -1;
    }

    try {
      id = await _messaggiRisposteController.addMessage(text);

      for (var chatId in chatIdS) {
        if (chatId != '') {
          _controller.sendMessage(int.parse(chatId),
              'Messaggio Automatico: $text\nCosa ne pensi? scrivi una risposta');
        }
      }
    } catch (e) {
      print(e);
    }

    return id;
  }

  Future<void> getResponse(int id) async {
    _streamSubscription = _controller.addMessageHandler((message, controller) {
      String text = message.text ?? '';

      if (text != '') {
        _messaggiRisposteController.addResponse(
            id, message.chat.id, message.text ?? '');
        message.reply('Risposta salvata');

        _streamSubscription.cancel();
      }
    });
  }
}
