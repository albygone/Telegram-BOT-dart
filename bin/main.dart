import 'dart:async';

import 'package:main/controller/telegram_bot_controller.dart';
import 'package:main/handlers/auto_msg_handler.dart';
import 'package:main/handlers/bar_handler.dart';
import 'package:main/handlers/user_handler.dart';

Future<void> main() async {
  const botToken = '6776833693:AAFudYdeaBwcPMNsO_wuMESQ-S4hSNTHmv4';

  setTimeout(callback) {
    return Timer(Duration(milliseconds: 1000), callback);
  }

  TelegramBotController _controller = TelegramBotController(botToken);
  await _controller.build();

  var userHandler = UserHandler(_controller);
  var autoMsgHandler = AutoMsgHandler(_controller);
  var barHandler = BarHandler(_controller);

  _controller.addCommandHandler('start', (message, controller) {
    message.reply('Ciao, che esercizio vuoi eseguire?',
        replyMarkup: _controller.buildInlineKeyboard([
          [
            ("Esercizio 1 (Invio messaggi automatico)", "autoMsg"),
          ],
          [
            ("Esercizio 2 (Prenotazioni Bar)", "bar"),
          ],
          [
            ("Esercizio 3 (🚧 Work in progress)", "work"),
          ],
          [
            ("Registrati come utente", "user"),
          ]
        ]));
  });

  _controller.addCommandHandler('user', (message, controller) {
    userHandler.addUser(message);
  });

  _controller.addCallbackQueryHandler('user', (inlineQuery, colntroler) {
    userHandler.addUser(inlineQuery.teledartMessage);
  });

  _controller.addCallbackQueryHandler('autoMsg', (inlineQuery, controller) {
    autoMsgHandler.start(inlineQuery.teledartMessage);
  });

  _controller.addCommandHandler('automsg', (message, controller) {
    autoMsgHandler.start(message);
  });

  _controller.addCallbackLikeQueryHandler('bar', (inlineQuery, controller) {
    barHandler.start(inlineQuery.teledartMessage);
  });

  _controller.addCommandHandler('bar', (message, controller) {
    barHandler.start(message);
  });

  _controller.addCallbackLikeQueryHandler('product', (inlineQuery, controller) {
    barHandler.handleResponse(inlineQuery.teledartMessage,
        int.parse(inlineQuery.data?.split('_')[1] ?? '-1'));
  });

  _controller.start();
}

Timer setTimeout(callback, [int duration = 1000]) {
  return Timer(Duration(milliseconds: duration), callback);
}

void clearTimeout(Timer t) {
  t.cancel();
}
