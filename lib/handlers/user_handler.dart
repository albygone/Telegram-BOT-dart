import 'dart:async';
import 'package:main/controller/telegram_bot_controller.dart';
import 'package:main/controller/user_controller.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

class UserHandler {
  final userController = UserController();

  late TelegramBotController _controller;
  late StreamSubscription _streamSubscription;

  UserHandler(TelegramBotController controller) {
    _controller = controller;
  }

  Future<void> addUser(TeleDartMessage? message) async {
    int id = message?.chat.id ?? 0;
    if (id != 0) {
      _streamSubscription = _controller.addMessageHandler(newUserHandler);
      message?.reply("Inserisci nome e cognome");
    } else {
      message?.reply('Errore, riprova più tardi');
    }
  }

  Future<void> newUserHandler(
      TeleDartMessage message, TeleDart controller) async {
    String nameSurname = message.text ?? '';

    if (nameSurname != '') {
      await userController.addUser(message.chat.id, nameSurname);

      message.reply('Utente inserito correttamente');

      await _streamSubscription.cancel();
    } else {
      message.reply('Inserisci nome e cognome');
    }
  }
}
