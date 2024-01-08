import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:main/models/mesuration.dart';

class TempController {
  Future<String> getTemp() async {
    String temp = '';
    Uri url = Uri.http('albygone.it:8080', '/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<String> mesuration = response.body.toString().split('\n');

      mesuration.removeLast();

      mesuration = mesuration.last.split(';');

      var mesurationObj = Mesuration(
          mesuration[0], mesuration[1], mesuration[2], mesuration[3]);

      temp =
          'Primario: ${mesurationObj.main}°C\nSecondario: ${mesurationObj.second}°C\nUmidità: ${mesurationObj.humidity}%\nUltimo aggiornamento: ${mesurationObj.dateTimeToString()}';
    } else {
      throw Exception('Failed to retreive data');
    }

    return temp;
  }
}
