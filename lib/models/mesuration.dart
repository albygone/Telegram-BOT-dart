class Mesuration {
  double main = 0.0;
  double second = 0.0;
  double humidity = 0;
  DateTime dateTime = DateTime.now();

  Mesuration(String main, String second, String humidity, String timeStamp) {
    try {
      this.main = double.parse(double.parse(main).toStringAsFixed(2));
      this.second = double.parse(double.parse(second).toStringAsFixed(2));
      this.humidity = double.parse(double.parse(humidity).toStringAsFixed(2));
      dateTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(timeStamp) * (timeStamp.length > 10 ? 1 : 1000));
    } catch (ex) {
      this.main = -1;
      this.second = -1;
      this.humidity = -1;
      this.dateTime = DateTime.now();

      print(ex.toString());
    }
  }

  String dateToString() {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String timeToString() {
    return '${dateTime.hour}:${dateTime.minute}';
  }

  String dateTimeToString() {
    return '${dateToString()} ${timeToString()}';
  }
}
