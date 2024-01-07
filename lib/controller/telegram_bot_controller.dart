import 'dart:async';

import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:teledart/model.dart';

class TelegramBotController {
  late String _botToken;
  late String _userName;
  late TeleDart _controller;

  TelegramBotController(String botToken) {
    _botToken = botToken;
  }

  Future<void> build() async {
    _userName = (await Telegram(_botToken).getMe()).username ?? '';
    _controller = TeleDart(_botToken, Event(_userName));
  }

  void start() {
    _controller.start();
  }

  void sendMessage(int chatId, String text) {
    _controller.sendMessage(chatId, text);
  }

  StreamSubscription addMessageHandler(
      void Function(TeleDartMessage message, TeleDart controller) onData) {
    return _controller
        .onMessage()
        .listen((message) => onData(message, _controller));
  }

  void addCommandHandler(String command,
      void Function(TeleDartMessage message, TeleDart controller) onData) {
    _controller
        .onCommand(command)
        .listen((message) => onData(message, _controller));
  }

  void addInlineQueryHandler(
      String query,
      void Function(TeleDartInlineQuery inlineQuery, TeleDart controller)
          onData) {
    _controller
        .onInlineQuery()
        .where((event) => event.query == query)
        .listen((inlineQuery) => onData(inlineQuery, _controller));
  }

  void addCallbackLikeQueryHandler(
      String query,
      void Function(TeleDartCallbackQuery inlineQuery, TeleDart controller)
          onData) {
    _controller
        .onCallbackQuery()
        .where((event) => event.data?.contains(query) ?? false)
        .listen((callbackQuery) {
      onData(callbackQuery, _controller);
    });
  }

  void addCallbackQueryHandler(
      String query,
      void Function(TeleDartCallbackQuery inlineQuery, TeleDart controller)
          onData) {
    _controller
        .onCallbackQuery()
        .where((event) => event.data == query)
        .listen((callbackQuery) {
      onData(callbackQuery, _controller);
    });
  }

  InlineKeyboardMarkup buildInlineKeyboard(
      List<List<(String, String)>> options) {
    var inlineKeyboard = options
        .map((option) => option
            .map((option) =>
                InlineKeyboardButton(text: option.$1, callbackData: option.$2))
            .toList())
        .toList();

    InlineKeyboardMarkup markUp =
        InlineKeyboardMarkup(inlineKeyboard: inlineKeyboard);

    return markUp;
  }

  ReplyKeyboardMarkup builReplyKeyboard(List<String> options) {
    var replyKeyboard =
        options.map((option) => KeyboardButton(text: option)).toList();

    var masterReplyKeyboard = [replyKeyboard];

    ReplyKeyboardMarkup markUp =
        ReplyKeyboardMarkup(keyboard: masterReplyKeyboard);

    return markUp;
  }
}
