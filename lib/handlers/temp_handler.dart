import 'dart:async';
import 'package:main/controller/telegram_bot_controller.dart';
import 'package:main/controller/temp_controller.dart';
import 'package:main/controller/user_controller.dart';
import 'package:main/handlers/user_handler.dart';
import 'package:teledart/model.dart';

class TempHandler {
  TempHandler(TelegramBotController controller) {
    _controller = controller;
    userHandler = UserHandler(_controller);
  }

  final userController = UserController();
  late UserHandler userHandler;

  late TelegramBotController _controller;

  final _tempHandler = TempController();

  Future<void> start(TeleDartMessage? message) async {
    try {
      if (await userController.checkUser(message!.chat.id)) {
        String temp = await _tempHandler.getTemp();

        message.reply(
            'Benvenuto nel serivizio di temperatura automatica, l\'ultima temperatura registrata è:\n\n$temp');
      } else {
        message.reply(
            "Ciao ${message.chat.firstName}, registrati come utente per poter utilizzare il bot");

        userHandler.addUser(message);
      }
    } catch (e) {
      message?.reply('Errore, riprova più tardi $e');
    }
  }
}
